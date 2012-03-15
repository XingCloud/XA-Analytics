class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :report_id
      
      t.string :type
      #最近多久， 最近1天 最近1周 最近一个月
      t.string :rule
      #频率  5分钟图 小时图 天图
      t.string :rate
      
      #如果有多个对比图 则控制label个数
      t.string :label_number
      
      #如果只有一个图可自动调整 x label
      #t.string :auto_adjust
      
      #对比个数
      t.integer :compare_number, :null => false, :default => 0
      t.timestamps
    end
    
    add_index :periods, [:report_id, :type]
  end
end