module Word 

    type Word = Word of string

    let createWord (s:string) = 
        if Seq.isEmpty s |> not then
            String.filter (fun c -> c <> '\n') s
            |> Word |> Some
        else
            None

    let lastChar word =
        match word with
        | Word s -> Seq.last s

    let firstChar word =
        match word with
        | Word s -> Seq.head s

//    let notEmpty word =
//        match word with
//        | Word s -> not <| Seq.isEmpty s

    let printWord w =
        match w with
        | Word s -> printfn "%s" s

    let endChars = ['.'; '!'; '?']

    let containsEndChar word =
        match word with
        | Word s -> Seq.exists (fun c -> Seq.contains c endChars) s

