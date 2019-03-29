all: init test

stop:
	sudo service slapd stop
start:
	sudo service slapd start

remove_data:
	sudo -u openldap find /var/lib/slapd -type f -exec rm {} \;

load_init_data:
	sudo -u openldap slapadd -l init_data.ldif

add_users:
	ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin -f user.ldif

authenticate-%:
	@ldapwhoami -e ppolicy -x -D "uid=user1,ou=people,dc=example,dc=com" -w user1 >/dev/null 2>&1 && echo "Succesful Auth: user1" || echo "Failed auth: user1"
	@ldapwhoami -e ppolicy -x -D "uid=user2,ou=people,dc=example,dc=com" -w user2 >/dev/null 2>&1 && echo "Succesful Auth: user2" || echo "Failed auth: user2"
	@ldapwhoami -e ppolicy -x -D "uid=user3,ou=people,dc=example,dc=com" -w user3 >/dev/null 2>&1 && echo "Succesful Auth: user3" || echo "Failed auth: user3"
	@ldapwhoami -e ppolicy -x -D "uid=user4,ou=people,dc=example,dc=com" -w user4 >/dev/null 2>&1 && echo "Succesful Auth: user4" || echo "Failed auth: user4"
	@ldapwhoami -e ppolicy -x -D "uid=user5,ou=people,dc=example,dc=com" -w user5 >/dev/null 2>&1 && echo "Succesful Auth: user5" || echo "Failed auth: user5"

maxage:
	@echo "Set maxage for user1, user2"
	@ldapmodify -x -D "cn=admin,dc=example,dc=com" -w admin -f maxage.ldif >/dev/null 2>&1

pwdAccountLockedTime:
	@echo "Set pwdAccountLockedTime: 000001010000Z for user3, pwdLockout: TRUE"
	@ldapmodify -x -D "cn=admin,dc=example,dc=com" -w admin -f pwdAccountLockedTime.ldif >/dev/null 2>&1

pwdAccountLockedTime_nopwdlockout:
	@echo "Set pwdAccountLockedTime: 000001010000Z for user4, pwdLockout: FALSE"
	@ldapmodify -x -D "cn=admin,dc=example,dc=com" -w admin -f pwdAccountLockedTime_nopwdlockout.ldif >/dev/null 2>&1

combined:
	@echo "Set pwdAccountLockedTime: 000001010000Z for user5, pwdLockout: TRUE, maxage: 1"
	@ldapmodify -x -D "cn=admin,dc=example,dc=com" -w admin -f combined.ldif >/dev/null 2>&1

resetpass_by_root-%:
	@echo "admin account resets pass. Note we dont reset the pass for user2"
	@ldappasswd -x -D "cn=admin,dc=example,dc=com" -w admin -s user1 uid=user1,ou=people,dc=example,dc=com
	@ldappasswd -x -D "cn=admin,dc=example,dc=com" -w admin -s user3 uid=user3,ou=people,dc=example,dc=com
	@ldappasswd -x -D "cn=admin,dc=example,dc=com" -w admin -s user4 uid=user4,ou=people,dc=example,dc=com
	@ldappasswd -x -D "cn=admin,dc=example,dc=com" -w admin -s user5 uid=user5,ou=people,dc=example,dc=com
	@sleep 2

resetpass_by_user:
	@echo "User accounts resets pass"
	-ldappasswd -x -D "uid=user1,ou=people,dc=example,dc=com" -w user1 -s user1 uid=user1,ou=people,dc=example,dc=com
	-ldappasswd -x -D "uid=user2,ou=people,dc=example,dc=com" -w user2 -s user2 uid=user2,ou=people,dc=example,dc=com
	-ldappasswd -x -D "uid=user3,ou=people,dc=example,dc=com" -w user3 -s user3 uid=user3,ou=people,dc=example,dc=com
	-ldappasswd -x -D "uid=user4,ou=people,dc=example,dc=com" -w user4 -s user4 uid=user4,ou=people,dc=example,dc=com
	-ldappasswd -x -D "uid=user5,ou=people,dc=example,dc=com" -w user5 -s user5 uid=user5,ou=people,dc=example,dc=com

init: stop remove_data load_init_data start add_users resetpass_by_root-init authenticate-init

lockout: maxage pwdAccountLockedTime pwdAccountLockedTime_nopwdlockout combined authenticate-lockout

root_pass_reset: resetpass_by_root-test authenticate-root_reset_pass

user_pass_reset: resetpass_by_user authenticate-user_pass_reset

test: lockout root_pass_reset user_pass_reset
