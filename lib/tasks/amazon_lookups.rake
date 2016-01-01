task :amazon_lookups => :environment do
  require 'asin'

  logger = Logger.new('log/rake_amazon_lookups.log')
  logger.info "#{Time.now}"

  dd4_cat_id = 1
  pathfinder_cat_id = 2
  dd35_cat_id = 4
  dd3_cat_id = 5
  #add_cat_id = 6
  #add2_cat_id = 7
  sw1_cat_id = 8
  swsaga_cat_id = 9

  paizo_user_id = 11274
  pathfinder_isbns = [
      '978-1-60125-150-3',
      '978-1-60125-183-1',
      '978-1-60125-246-3',
      '978-1-60125-216-6',
      '978-1-60125-217-3',
      '978-1-60125-268-5',
      '978-1-60125-299-9',
      '978-1-60125-359-0',
      '978-1-60125-378-1',
      '978-1-60125-390-3',
      '978-1-60125-445-0',
      '978-1-60125-424-5',
      '978-1-60125-449-8',
      '978-1-60125-467-2',
      '978-1-60125-472-6' ]

  wotc_user_id = 10917
  sw1_corebook_isbns = [
      '0-7869-2876-X',
      '0-7869-2663-5',
      '0-7869-2879-4',
      '0-7869-2892-1',
      '0-7869-3133-7',
      '0-7869-2883-2',
      '0-7869-1792-X',
      '0-7869-1963-9',
      '0-7869-2777-1',
      '0-7869-2781-X',
      '0-7869-1837-3',
      '0-7869-1794-6',
      '0-7869-1839-X',
      '0-7869-2782-8',
      '0-7869-1833-0',
      '0-7869-1793-8',
      '786918594',
      '0-7869-1849-7',
      '0-7869-3054-3',
      '0-7869-2888-3']

  swsaga_corebook_isbns = [
      '978-0786947430',
      '978-0786949236',
      '978-0786947812',
      '978-0-7869-4823-9',
      '978-0-7869-4356-2' ]

  dd3_corebook_isbns = [
      '0-7869-1550-1',
      '978-0-7869-2649-7',
      '978-0-7869-2657-2',
      '978-0-7869-2650-3',
      '978-0-7869-1840-9',
      '978-0-7869-2654-1',
      '978-0786915514',
      '978-0-7869-1852-2',
      '978-0-7869-2658-9',
      '978-0-7869-2780-7',
      '978-0-7869-1647-4',
      '978-0-7869-1850-8',
      '978-0-7869-2653-4',
      '978-0-7869-2893-4',
      '978-0-7869-2873-6',
      '0-7869-2015-7',
      '978-078691835-5',
      '0-7869-2648-1',
      '0-7869-1857-8',
      '0-7869-2655-4',
      '0-7869-1829-2',
      '0-7869-1845-4']

  dd3_isbns = [
      '0-7869-1742-3',
      '0-7869-1742-3',
      '0-7869-1836-5',
      '978-0-7869-2834-7',
      '0-7869-1743-1',
      '0-7869-1989-2',
      '0-7869-1832-2',
      '0-7869-2875-1',
      '0-7869-2835-2',
      '0-7869-1996-5']

  dd35_corebook_isbns = [
      '0-7869-3918-4',
      '978-0-7869-3136-1',
      '978-0-7869-3939-8',
      '978-0-7869-3651-9',
      '978-0-7869-3435-5',
      '978-0-7869-4034-9',
      '978-0-7869-3272-6',
      '978-0-7869-3937-4',
      '978-0-7869-3911-4',
      '978-0-7869-4152-0',
      '978-0-7869-2880-4',
      '978-0-7869-2884-2',
      '978-0-7869-3936-7',
      '978-0-7869-4151-3',
      '978-0-7869-2889-7',
      '978-0-7869-3687-8',
      '978-0-7869-4730-0',
      '978-0-7869-4118-6',
      '978-0-7869-4733-1',
      '978-0-7869-4361-6',
      '978-0-7869-3301-3',
      '978-0-7869-3919-0',
      '978-0-7869-3940-4',
      '978-0-7869-2896-5',
      '978-0-7869-3686-1',
      '978-0-7869-3699-1',
      '978-0-7869-3433-1',
      '978-0-7869-3657-1',
      '978-0-7869-3701-1',
      '978-0-7869-4345-6',
      '978-0-7869-3281-8',
      '0-7869-2893-X',
      '0-7869-3430-1',
      '0-7869-3920-6',
      '978-0-7869-4115-5',
      '0-7869-3429-8',
      '0-7869-2886-7',
      '0-7869-3653-3',
      '0-7869-3278-3',
      '0-7869-3913-3',
      '0-7869-3438-7',
      '0-7869-4725-X',
      '0-7869-3655-X',
      '0-7869-3702-5',
      '0-7869-3689-4',
      '0-7869-3922-2',
      '0-7869-3909-5',
      '0-7680-3131-0',
      '0-7869-3688-6' ]

  dd35_isbns = [
      '0-7869-3692-4',
      '0-7869-3697-5',
      '0-7869-3693-2',
      '978-0-7869-4803-1',
      '0-7869-3086-1',
      '0-7869-3933-8',
      '978-0-7869-4154-4',
      '0-7869-3923-0',
      '0-7869-3274-0',
      '978-0-7869-4855-0',
      '0-7869-3691-6',
      '0-7869-3934-6',
      '0-7869-3690-8',
      '978-0-7869-4731-7',
      '0-7869-3654-1',
      '0-7869-3696-7',
      '0-7869-1964-7',
      '0-7869-3915-X',
      '0-7869-3912-5',
      '0-7869-3134-5',
      '0-7869-3910-9',
      '0-7869-3658-4',
      '978-0-7869-4037-0',
      '0-7869-3916-8',
      '0-7869-3277-5',
      '0-7869-3434-4',
      '0-7869-3492-1',
      '978-0-7869-4153-7',
      '0-7869-2881-6',
      '0-7869-3053-5' ]

  dd4_corebook_isbns = [
      '978-0786953905',
      '978-0-7869-4880-2',
      '978-0-7869-4852-9',
      '978-0-7869-4978-6',
      '978-0-7869-4978-6',
      '9780786952045',
      '9780786949571',
      '978-0786958689',
      '978-0786954933',
      '978-0786954940',
      '978-0786954926',
      '978-0786949823',
      '978-0-7869-4980-9',
      '9780786952489',
      '978-0-7869-4867-3',
      '978-0786952458',
      '978-0786951390',
      '978-0786952441',
      '978-0786950997',
      '9780786951000',
      '978-0-7869-4924-3',
      '978-0-7869-4929-8',
      '978-0786955343',
      '978-0786960323',
      '978-0-7869-5002-7',
      '978-0-7869-4981-6',
      '0786953896',
      '978-0786951017',
      '253840000',
      '978-0786957446',
      '978-0786958146',
      '978-0786950690',
      '978-0786953929',
      '978-0786952496',
      '0786954884',
      '9780786950164',
      '978-0786953868',
      '978-0786954896',
      '978-0786957453',
      '978-0786958368',
      '978-0786959815',
      '978-0786950232',
      '978-0786955602',
      '978-0786958481',
      '978-0786953875',
      '978-0786955497',
      '978-0786948017',
      '978-0786948024',
      '978-0786956203',
      '978-0786956197',
      '978-0786956319',
      '978-0786958382',
      '978-0786956210']

  tsr_user_id = 11275
  #add2_corebook_isbns = []
  #add_corebook_isbns = [

  tsr_isbns = [
      '0880380527',
      '0935696016',
      '0880387297',
      '978-0-935696-01-1',
      '978-0-935696-02-8',
      '978-1-56076-412-0',
      '978-0-88038-716-3',
      '978-0-88038-729-3',
      '978-0-935696-00-4',
      '978-0-935696-01-1',
      '978-0-935696-02-8',
      '978-0-394-51111-5',
      '978-0-394-51834-3',
      '978-0-394-52198-5',
      '978-0-88038-338-7',
      '978-0-88038-339-4',
      '978-0-88038-342-4',
      '978-0-88038-340-0',
      '978-0-88038-341-7',
      '978-1-56076-085-6']

  #corebooks = {
  #    '978-0-935696-02-8' => "AD&D: Dungeon Master's Guide",
  #    '978-0-935696-01-1' => "AD&D: Player's Handbook",
  #    '978-0-935696-00-4' => "AD&D: Monster Manual",
  #
  #    '0880387297'        => "AD&D 2nd edition: Dungeon Master's Guide",
  #    '0935696016'        => "AD&D 2nd edition: Player's Handbook",
  #    '978-0880387385'    => "AD&D 2nd edition: Monstrous Compendium",
  #    '0880380527'        => "AD&D 2nd edition: Monster Manual",
  #
  #    '978-0786915514'    => "D&D 3rd edition: Dungeon Master's Guide",
  #    '978-0786915507'    => "D&D 3rd edition: Player's Handbook",
  #    '978-0786915521'    => "D&D 3rd edition: Monster Manual",
  #
  #    '978-0786928897'    => "D&D 3.5 edition: Dungeon Master's Guide",
  #    '0786941928'        => "D&D 3.5 edition: Player's Handbook",
  #    '978-0786928934'    => "D&D 3.5 edition: Monster Manual",
  #
  #    '0786948809'        => "D&D 4th edition: Dungeon Master's Guide",
  #    '0786948671'        => "D&D 4th edition: Player's Handbook",
  #    '978-0786948529'    => "D&D 4th edition: Monster Manual",
  #    '078695244X'        => "D&D 4th edition: Dungeon Master's Guide 2",
  #    '0786950161'        => "D&D 4th edition: Player's Handbook 2",
  #    '978-0786951017'    => "D&D 4th edition: Monster Manual 2",
  #    '078695390X'        => "D&D 4th edition: Player's Handbook 3",
  #    '978-0786954902'    => "D&D 4th edition: Monster Manual 3"
  #}


  def poll_amazon(publisher_id, isbns, logger, is_corebook, category_id)
    asin_client = ASIN::Client.instance
    publisher = User.find(publisher_id)

    isbns.each do |isbn|
      logger.info "isbn: #{isbn}"

      product = Product.find_by_isbn(isbn)
      if product.nil?
        product = Product.new
        product.isbn = isbn
        product.name = 'Unnamed'
        product.save!
        publisher.products << product
      end

      if is_corebook
        product.is_core_rulebook = true
        #product.view_count += 2
      end

      isbn_wo_dashes = isbn.gsub('-', '')
      results = asin_client.lookup_book_from_isbn(isbn_wo_dashes)
      if results.any?
        result = results.first
        books = asin_client.lookup(result.asin)

        if books.any?
          book = books.first
          logger.info "name: #{book.title}"
          logger.info "price: #{book.amount}"
          logger.info "asin: #{book.asin}"
          logger.info "image url: #{book.image_url}"
          logger.info "details url: #{book.details_url}"

          product.name = book.title
          #product.description = book.review
          #product.price = book.amount
          product.amazon_asin = book.asin
          product.amazon_image_url = book.image_url
          product.purchase_book_url = book.details_url

          if category_id > 0
            system_category = SystemCategory.find(category_id)
            if system_category
              system_category.products << product
            end
          end

          product.save!

          if product.name_slug.blank?
            product.save!
          end
        else
          logger.error "lookup by asin returned empty"
        end
      else
        logger.error "lookup by isbn returned empty"
      end

      logger.info ""
    end
  end

  def empty_category(category_id)
    if category_id > 0
      system_category = SystemCategory.find(category_id)
      if system_category
        system_category.products = []
      end
    end
  end

  empty_category(dd3_cat_id)
  empty_category(dd35_cat_id)
  empty_category(dd4_cat_id)
  empty_category(sw1_cat_id)
  empty_category(swsaga_cat_id)
  empty_category(pathfinder_cat_id)

  poll_amazon(wotc_user_id, dd3_corebook_isbns, logger, true, dd3_cat_id)
  poll_amazon(wotc_user_id, dd3_isbns, logger, false, 0)
  poll_amazon(wotc_user_id, dd35_corebook_isbns, logger, true, dd35_cat_id)
  poll_amazon(wotc_user_id, dd35_isbns, logger, false, 0)
  poll_amazon(wotc_user_id, dd4_corebook_isbns, logger, true, dd4_cat_id)
  poll_amazon(wotc_user_id, sw1_corebook_isbns, logger, true, sw1_cat_id)
  poll_amazon(wotc_user_id, swsaga_corebook_isbns, logger, true, swsaga_cat_id)

  poll_amazon(paizo_user_id, pathfinder_isbns, logger, true, pathfinder_cat_id)
  poll_amazon(tsr_user_id, tsr_isbns, logger, true, 0)

end
