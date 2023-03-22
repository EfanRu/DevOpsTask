# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

### Задание 1
    Установите molecule: pip3 install "molecule==3.5.2".

### Решение 1
    Сделано.

### Задание 2
    Выполните docker pull aragast/netology:latest — это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

### Решение 2
    Сделано.

## Основная часть
    Ваша цель — настроить тестирование ваших ролей.
    Задача — сделать сценарии тестирования для vector.
    Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

## Molecule

### Задание 1
    Запустите 'molecule test -s centos_7' внутри корневой директории clickhouse-role, посмотрите на вывод команды. 
    Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
   
### Решение 1

<details><summary>Вывод в консоль:</summary>

```commandline
molecule test -s centos_7
---
dependency:
  name: galaxy
driver:
  name: docker
  options:
    D: true
    vv: true
lint: 'yamllint .

  ansible-lint

  flake8

  '
platforms:
  - capabilities:
      - SYS_ADMIN
    command: /usr/sbin/init
    dockerfile: ../resources/Dockerfile.j2
    env:
      ANSIBLE_USER: ansible
      DEPLOY_GROUP: deployer
      SUDO_GROUP: wheel
      container: docker
    image: centos:7
    name: centos_7
    privileged: true
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
provisioner:
  inventory:
    links:
      group_vars: ../resources/inventory/group_vars/
      host_vars: ../resources/inventory/host_vars/
      hosts: ../resources/inventory/hosts.yml
  name: ansible
  options:
    D: true
    vv: true
  playbooks:
    converge: ../resources/playbooks/converge.yml
verifier:
  name: ansible
  playbooks:
    verify: ../resources/tests/verify.yml

CRITICAL Failed to pre-validate.

{'driver': [{'name': ['unallowed value docker']}]}
```

<details>

### Задание  2
   Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при 
   помощи `molecule init scenario --driver-name docker`.

### Решение 2
    
<details><summary>Приведенная команда возвращает ощибку:</summary>

```commandline
molecule init scenario --driver-name docker
Usage: molecule init scenario [OPTIONS] [SCENARIO_NAME]
Try 'molecule init scenario --help' for help.

Error: Invalid value for '--driver-name' / '-d': 'docker' is not 'delegated'.
```

<details>

<details><summary>Доустанавливаем molecule-docker и повторяем запуск:</summary>

```commandline
pip install molecule-docker
...
molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector-role/molecule/default successfully.
```

<details>

### Задание 3
    Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
   
### Решение 3
   Добавил информацию о нескольких дистрибутивах в файл molecule.yml
[molecule.yml](vector-role%2Fmolecule%2Fdefault%2Fmolecule.yml)
   

<details><summary>Вывод в консоль:</summary>

```commandline
molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector-role/molecule/default successfully.
slava@slava-FLAPTOP-r:~/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector-role$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/slava/.cache/ansible-compat/f5bcd7/modules:/home/slava/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/slava/.cache/ansible-compat/f5bcd7/collections:/home/slava/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/slava/.cache/ansible-compat/f5bcd7/roles:/home/slava/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
ERROR    Computed fully qualified role name of vector-role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

Traceback (most recent call last):
  File "/home/slava/.local/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/usr/lib/python3/dist-packages/click/core.py", line 1128, in __call__
    return self.main(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/click/core.py", line 1053, in main
    rv = self.invoke(ctx)
  File "/usr/lib/python3/dist-packages/click/core.py", line 1659, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/usr/lib/python3/dist-packages/click/core.py", line 1395, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/usr/lib/python3/dist-packages/click/core.py", line 754, in invoke
    return __callback(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/click/decorators.py", line 26, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/home/slava/.local/lib/python3.10/site-packages/molecule/command/test.py", line 176, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/home/slava/.local/lib/python3.10/site-packages/molecule/command/base.py", line 112, in execute_cmdline_scenarios
    scenario.config.runtime.prepare_environment(
  File "/usr/local/lib/python3.10/dist-packages/ansible_compat/runtime.py", line 421, in prepare_environment
    self._install_galaxy_role(
  File "/usr/local/lib/python3.10/dist-packages/ansible_compat/runtime.py", line 581, in _install_galaxy_role
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Computed fully qualified role name of vector-role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.
```

<details>

   Ошибка была вызвана тем, что у роль была названа vector-role, а в ansible galaxy запрещается в названии использовать 
   знаки "-". Заменив их на "_" и перезапустив получаем следующий результат:

<details><summary>Вывод в консоль:</summary>

```commandline
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/slava/.cache/ansible-compat/e3fa2b/modules:/home/slava/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/slava/.cache/ansible-compat/e3fa2b/collections:/home/slava/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/slava/.cache/ansible-compat/e3fa2b/roles:/home/slava/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/slava/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
...
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '708612613381.42290', 'results_file': '/home/slava/.ansible_async/708612613381.42290', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
...
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '341440674071.42316', 'results_file': '/home/slava/.ansible_async/341440674071.42316', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Download Vector] *******************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector_role : Install Vector] ********************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {"pkg_mgr": "apt"}, "changed": false, "msg": ["Could not detect which major revision of yum is in use, which is required to determine module backend.", "You should manually specify use_backend to tell the module whether to use the yum (yum3) or dnf (yum4) backend})"]}
fatal: [centos8]: FAILED! => {"changed": false, "msg": "Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist", "rc": 1, "results": []}

PLAY RECAP *********************************************************************
centos8                    : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

WARNING  Retrying execution failure 2 of: ansible-playbook --inventory /home/slava/.cache/molecule/vector_role/default/inventory --skip-tags molecule-notest,notest /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/molecule/default/converge.yml
CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/slava/.cache/molecule/vector_role/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

<details>

   У нас получились ошибки при установке Vector:

<details><summary>Вывод в консоль:</summary>

```commandline
TASK [vector_role : Install Vector] ********************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {"pkg_mgr": "apt"}, "changed": false, "msg": ["Could not detect which major revision of yum is in use, which is required to determine module backend.", "You should manually specify use_backend to tell the module whether to use the yum (yum3) or dnf (yum4) backend})"]}
fatal: [centos8]: FAILED! => {"changed": false, "msg": "Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist", "rc": 1, "results": []}
```

<details>
   
   Испраляем их. Пришлось сделать отдельные play для Centos и для Ubuntu.

<details><summary>Вывод в консоль:</summary>

```commandline
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/slava/.cache/ansible-compat/e3fa2b/modules:/home/slava/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/slava/.cache/ansible-compat/e3fa2b/collections:/home/slava/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/slava/.cache/ansible-compat/e3fa2b/roles:/home/slava/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/slava/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '779236596489.24942', 'results_file': '/home/slava/.ansible_async/779236596489.24942', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '779101350467.24968', 'results_file': '/home/slava/.ansible_async/779101350467.24968', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Prepare Centos] ********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Prepare Centos] ********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

<details>

### Задание 4
   Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

### Решение 4
   Сделана проверка на версию и на валидацию vector
[verify.yml](vector_role%2Fmolecule%2Fdefault%2Fverify.yml)

### Задание 5
   Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

### Решение 5
   Не прошел тест на идемпотемптность. Хотя вроде сделал несколько условий. Тут требуется Ваш совет.

<details><summary>Вывод в консоль:</summary>

```commandline
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/slava/.cache/ansible-compat/e3fa2b/modules:/home/slava/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/slava/.cache/ansible-compat/e3fa2b/collections:/home/slava/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/slava/.cache/ansible-compat/e3fa2b/roles:/home/slava/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/slava/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=Centos)
ok: [localhost] => (item=Ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '617322976601.28032', 'results_file': '/home/slava/.ansible_async/617322976601.28032', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '248338109766.28058', 'results_file': '/home/slava/.ansible_async/248338109766.28058', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Centos]
ok: [Ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
fatal: [Centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001739", "end": "2023-03-21 20:09:38.024975", "msg": "non-zero return code", "rc": 2, "start": "2023-03-21 20:09:38.023236", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
skipping: [Ubuntu]
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [Centos]
changed: [Ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [Centos]
changed: [Ubuntu]

PLAY RECAP *********************************************************************
Centos                     : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1
Ubuntu                     : ok=3    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Centos]
ok: [Ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
fatal: [Centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001824", "end": "2023-03-21 20:10:26.013544", "msg": "non-zero return code", "rc": 2, "start": "2023-03-21 20:10:26.011720", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
skipping: [Ubuntu]
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [Ubuntu]
ok: [Centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [Ubuntu]
ok: [Centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [Centos]
ok: [Ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [Centos]
changed: [Ubuntu]

PLAY RECAP *********************************************************************
Centos                     : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1
Ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

CRITICAL Idempotence test failed because of the following tasks:
* [Centos] => vector_role : Prepare Centos
* [Ubuntu] => vector_role : Install Vector Ubuntu
WARNING  An error occurred during the test sequence action: 'idempotence'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

<details>

### Задание 6
   Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Решение 6
[Коммит с изменения в vector_role](https://github.com/EfanRu/vector-role/tree/0.0.2)


## Tox

### Задание 1
   Добавьте в директорию с vector-role файлы из директории ./example

### Решение 1
   Сделано.
[tox.ini](vector_role%2Ftox.ini)
[tox-requirements.txt](vector_role%2Ftox-requirements.txt)

### Задание 2
   Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.

### Решение 2
   Сделано.
```commandline
docker run --privileged=True -v ~/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
```

### Задание 3
   Внутри контейнера выполните команду `tox`, посмотрите на вывод.

### Решение 3
   Что-то все зафейлилось(
   Пробовал и локально и через образ что дали в команде с докером, щтак и не получилось решить проблему, но видимо и 
   в задании нет требования это фиксить.

<details><summary>Вывод в консоль:</summary>

```commandline
tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='3762053039'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='3762053039'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.3,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='3762053039'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.3,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='3762053039'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
____________________________________________________________________________________ summary ____________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```

<details>

### Задание 5
   Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
   
### Решение 5
   Не смог победить ошибку:
      ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
   Пробовал и устанавливать другие версии и запускать разные версии python/ansible.
   
<details><summary>Вывод в консоль:</summary>

```commandline
tox
py39-ansible30 create: /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.3,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='4018830430'
py39-ansible30 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Guessed /home/slava/Documents/DevOpsTask as project root directory
INFO     Using /home/slava/.cache/ansible-lint/cf8d39/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/slava/.cache/ansible-lint/cf8d39/roles
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'
Traceback (most recent call last):
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1130, in __call__
    return self.main(*args, **kwargs)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1055, in main
    rv = self.invoke(ctx)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1657, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1404, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 760, in invoke
    return __callback(*args, **kwargs)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/click/decorators.py", line 26, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 119, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 161, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 150, in execute_subcommand
    return command(config).execute()
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/logger.py", line 187, in wrapper
    rt = func(*args, **kwargs)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
    pb.execute()
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 106, in execute
    self._config.driver.sanity_checks()
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule_podman/driver.py", line 212, in sanity_checks
    if runtime.version < Version("2.10.0") and runtime.config.ansible_pipelining:
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 208, in version
    self._version = parse_ansible_version(proc.stdout)
  File "/home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/config.py", line 39, in parse_ansible_version
    raise InvalidPrerequisiteError(
ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/slava/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible
  executable location = /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/bin/ansible
  python version = 3.9.16 (main, Dec  7 2022, 01:12:08) [GCC 11.3.0]

Keep in mind that only 2.12 or newer are supported.
ERROR: InvocationError for command /home/slava/Documents/DevOpsTask/src/task8_Ansible/Task_5_testing_roles/vector_role/.tox/py39-ansible30/bin/molecule test -s tox --destroy always (exited with code 1)
____________________________________________________________________________________ summary ____________________________________________________________________________________
ERROR:   py39-ansible30: commands failed
```

</details>


   Хотя если запустить полный сценарий, то она отображается только в конце:

<details><summary>Вывод в консоль:</summary>



</details>


### Задание 6
   Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
   
### Решение 6
   В задаче 5 выше приведен её вывод.
   Строка 
```commandline
posargs:molecule test -s tox --destroy always
```

### Задание 8
   Запустите команду `tox`. Убедитесь, что всё отработало успешно.

### Решение 8
   В задаче 5 выше приведен её вывод.

### Задание 9
   Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Решение 9
[Коммит с новым тегом](https://github.com/EfanRu/vector-role/tree/0.0.3)
---