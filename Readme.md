## Все команды

### Я использую Windows 10 поэтому команды таковы:

Чтобы собрать Docker Image:  ```docker build .\buildenv\ -t os-dev```

Запустить контейнер Docker'a: ```docker run --rm -it -v "${pwd}:/root/env" os-dev```

Запустить эмулятор: ```qemu-system-x86_64w.exe .\dist\x86_64\studos.iso```

Кроме qemu, можно использовать VM VirtualBox, однако, по какой-то причине, будет недоступен long mode.
