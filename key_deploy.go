package main

import (
  "fmt"
  "os"
  "log"
  )

func main() {

  const github_key string = ``
  const rubygems_key string = ``
  const signing_key string = ``
  const github_token string = ``

  gh_file, err := os.Create("/home/rof/.ssh/github-auto_key")
  if err != nil {
    fmt.Println("The file was not created")
    log.Fatal(err)
    os.Exit(1)

      return
  }
  defer gh_file.Close()
  gh_file.WriteString(github_key)

  rg_file, err := os.Create("/home/rof/.gem/credentials")
  if err != nil {
    fmt.Println("The file was not created")
    log.Fatal(err)
    os.Exit(1)

      return
  }
  defer rg_file.Close()
  rg_file.WriteString(rubygems_key)

  sp_file, err := os.Create("/home/rof/.ssh/gem-private_key.pem")
  if err != nil {
    fmt.Println("The file was not created")
    log.Fatal(err)
    os.Exit(1)

      return
  }
  defer sp_file.Close()
  sp_file.WriteString(signing_key)

  gh_token, err := os.Create("/home/rof/.ssh/gitub_token")
  if err != nil {
    fmt.Println("The file was not created")
    log.Fatal(err)
    os.Exit(1)

      return
  }
  defer gh_token.Close()
  gh_token.WriteString(github_token)
}
