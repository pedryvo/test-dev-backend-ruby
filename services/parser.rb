class Parser

  def initialize(json)
    @hash = JSON.parse(json)

    @estados = {
                  'Acre' => 'AC', 'Alagoas' => 'AL', 'Amapá' => 'AP', 'Amazonas' => 'AM',
                  'Bahia' => 'BA', 'Ceará' => 'CE', 'Distrito Federal' => 'DF', 'Espírito Santo' => 'ES',
                  'Goiás' => 'GO', 'Maranhão' => 'MA', 'Mato Grosso' => 'MT', 'Mato Grosso do Sul' => 'MS',
                  'Minas Gerais' => 'MG', 'Pará' => 'PA', 'Paraíba' => 'PB', 'Paraná' => 'PR',
                  'Pernambuco' => 'PE', 'Piauí' => 'PI', 'Rio de Janeiro' => 'RJ', 'Rio Grande do Norte' => 'RN',
                  'Rio Grande do Sul' => 'RS', 'Rondônia' => 'RO', 'Roraima' => 'RR', 'Santa Catarina' => 'SC',
                  'São Paulo' => 'SP', 'Sergipe' => 'SE', 'Tocantins' => 'TO'
               }
  end

  def format_timezone(datetime)
    # get miliseconds
    ms = datetime[/\.(.*?)-/,1]
    # transform to UTC and concat miliseconds
    datetime = DateTime.parse(datetime).to_time.utc.iso8601.insert(-2, ".#{ms}")
  end

  def payload
    data = {
        'externalCode' => @hash['id'].to_s,
        'storeId'=> @hash['store_id'],
        'subTotal'=> "%0.2f" % @hash['total_amount'].to_f,
        'deliveryFee'=> @hash['total_shipping'].to_s,
        'total_shipping'=> @hash['total_shipping'],
        'total'=> '61.90',
        'country'=> @hash['shipping']['receiver_address']['country']['id'],
        'state'=> @estados[@hash['shipping']['receiver_address']['state']['name']],
        'city'=> @hash['shipping']['receiver_address']['city']['name'],
        'district'=> 'Bairro Fake',
        'street'=> @hash['shipping']['receiver_address']['street_name'],
        'complement'=> 'galpao',
        'latitude'=> @hash['shipping']['receiver_address']['latitude'],
        'longitude'=>  @hash['shipping']['receiver_address']['longitude'],
        'dtOrderCreate'=> format_timezone(@hash['payments'][0]['date_created']),
        'postalCode'=> @hash['shipping']['receiver_address']['zip_code'],
        'number'=> @hash['payments'][0]['taxes_amount'].to_s,
        'customer'=> {
            'externalCode'=> @hash['buyer']['id'].to_s,
            'name'=> @hash['buyer']['nickname'],
            'email'=> @hash['buyer']['email'],
            'contact'=> @hash['shipping']['receiver_address']['receiver_phone']
        },
        'items'=> [
            {
                'externalCode'=> @hash['order_items'][0]['item']['id'],
                'name'=> @hash['order_items'][0]['item']['title'],
                'price'=> @hash['order_items'][0]['unit_price'],
                'quantity'=> @hash['order_items'][0]['quantity'],
                'total'=> @hash['order_items'][0]['full_unit_price'],
                'subItems'=> []
            }
        ],
        'payments'=> [
            {
                'type'=> @hash['payments'][0]['payment_type'].upcase,
                'value'=> @hash['payments'][0]['total_paid_amount'],
            }
        ]
    }
  end
end
