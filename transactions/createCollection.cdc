import BottomShot from 0xf8d6e0586b0a20c7

transaction {
  
  prepare(acct: AuthAccount) {
                                                // I changed the storage address here
    acct.save(<- BottomShot.createCollection(), to: /storage/BottomShot3)
    
    // We're linking two resources in different storage domains
    acct.link<&BottomShot.Collection{BottomShot.CollectionPublic}>
      (/public/BottomShot3, target: /storage/BottomShot3)
  }
  
  execute {
    log("Stored a collection for our NUTTY empty NFTs")
  }
}