# Ads

Microservice Ads

# Dependencies

- Ruby `2.6.6`
- Bundler `2.1.4`
- Sinatra `2.1+`
- Puma `5.5+`
- PostgreSQL `9.3+`

# Setup

```
bundle install
cp .env.example .env
```

Paste your database credentials to .env

```
rake db:create
rake db:migrate
```

3. Run app:

```
puma -p 3000
```

# Endpoints

Retrieve all ads
```
GET /api/v1/ads

params { page: :integer }
```

Create new ad
```
POST /api/v1/ads

params { ad: { title: :string, description: :string, city: :string }, user_id: :integer }
```

