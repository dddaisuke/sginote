# jQuery ->
#   $('.note_link').click (e) ->
#     # src = $(this).attr('href')
#     # alert src
#     # e.preventDefault
#     # alert $('#note_editor').attr('href')
#     # $('#note_editor').empty()
#     # $("#note_editor").attr("src", src)
#     false

jQuery ->
  $('.search').click (e) ->
    $.ajax
      type: "GET"
      url: "/notes/morpheme?sentence=豐臣 秀吉（とよとみ ひでよし[3]）/ 羽柴 秀吉（はしば ひでよし）は、戦国時代から安土桃山時代にかけての武将・天下人・関白・太閤。三英傑の一人。 はじめ木下氏を名字とし、羽柴氏に改める。本姓としては、はじめ平氏を自称するが、近衛家の猶子となり藤原氏に改姓した後、豊臣氏に改めた。 尾張国愛知郡中村郷の下層民の家に生まれた。当初今川家に仕えるも出奔した後に織田信長に仕官し、次第に頭角を表した。"
      cache: false
      success: (json) ->
        for word in json
          $.ajax
            type: 'GET'
            url: '/notes/find_word?word=' + word
            cache: true
            success: (json) ->
              if json['link'] != null
                # alert json['link']
                # alert '<a href="' + json['link'] + '">' + word + '</a>'
                $('#search_list').append('<div id="link"><a target="_blank" href="' + json['link'] + '">' + json['word'] + '</a></div')
    false

  # localhost:3000/notes/find_word?word=Google
