#!/usr/bin/python
import httplib

code_list = [
			"002738.SZ",
			"002125.SZ",
			"600241.SS",
			"002034.SZ",
			"002193.SZ",
			"600593.SS",
			"002058.SZ",
			"000668.SZ",
			"002188.SZ",
			"600719.SS",
			"600099.SS",
			"002209.SZ",
			"000796.SZ",
			"600605.SS",
			"002120.SZ",
			"600243.SS",
			"002352.SZ",
			"002201.SZ",
			"002682.SZ",
			"002647.SZ",
			"600233.SS",
			"000923.SZ",
			"002580.SZ",
			"002124.SZ",
			"002435.SZ",
			"002599.SZ",
			"002627.SZ",
			"000985.SZ",
			"000929.SZ",
			"600493.SS",
			"002295.SZ",
			"002395.SZ",
			"002076.SZ",
			"002620.SZ",
			"600152.SS",
			"002077.SZ",
			"600356.SS",
			"002205.SZ",
			"002150.SZ",
			"002213.SZ",
			"002696.SZ",
			"002112.SZ",
			"002319.SZ",
			"002530.SZ",
			"000615.SZ",
			"002455.SZ",
			"002553.SZ",
			"002136.SZ",
			"002558.SZ",
			"002634.SZ",
			"000610.SZ",
			"000593.SZ",
			"002147.SZ",
			"002735.SZ",
			"002036.SZ",
			"600370.SS",
			"600393.SS",
			"600070.SS",
			"002625.SZ",
			"000785.SZ",
			"002629.SZ",
			"002715.SZ",
			"600981.SS",
			"600796.SS",
			"600883.SS",
			"002523.SZ",
			"600293.SS",
			"000023.SZ",
			"002027.SZ",
			"600232.SS",
			"002270.SZ",
			"002082.SZ",
			"600746.SS",
			"002492.SZ",
			"002654.SZ",
			"002044.SZ",
			"600302.SS",
			"002365.SZ",
			"002667.SZ",
			"002569.SZ",
			"002660.SZ",
			"002607.SZ",
			"600095.SS",
			"600353.SS",
			"600573.SS",
			"603009.SS",
			"002347.SZ",
			"000565.SZ",
			"002619.SZ",
			"000019.SZ",
			"002632.SZ",
			"000836.SZ",
			"600856.SS",
			"000909.SZ",
			"600235.SS",
			"002066.SZ",
			"002323.SZ",
			"600986.SS",
			"603636.SS",
			"002494.SZ",
			"600423.SS",
			"002290.SZ",
			"600513.SS",
			"002357.SZ",
			"002380.SZ",
			"000707.SZ",
			"600371.SS",
			"002537.SZ",
			"002596.SZ",
			"002729.SZ",
			"002529.SZ",
			"002680.SZ",
			"002105.SZ",
			"002591.SZ",
			"600463.SS",
			"603010.SS",
			"002702.SZ",
			"002119.SZ",
			"002687.SZ",
			"002040.SZ",
			"002723.SZ",
			"002615.SZ",
			"002098.SZ",
			"603088.SS",
			"600560.SS",
			"002103.SZ",
			"600889.SS",
			"000421.SZ",
			"002590.SZ",
			"002087.SZ",
			"002536.SZ",
			"603006.SS",
			"002141.SZ",
			"000881.SZ",
			"002560.SZ",
			"600821.SS",
			"002057.SZ",
			"002517.SZ",
			"002086.SZ",
			"600992.SS",
			"600452.SS",
			"002464.SZ",
			"000032.SZ",
			"002679.SZ",
			"000833.SZ",
			"000702.SZ",
			"603017.SS",
			"002669.SZ",
			"600774.SS",
			"000911.SZ",
			"600215.SS",
			"002196.SZ",
			"600165.SS",
			"002652.SZ",
			"002676.SZ",
			"002562.SZ",
			"600189.SS",
			"002043.SZ",
			"002343.SZ",
			"000626.SZ",
			"000679.SZ",
			"600051.SS",
			"002208.SZ",
			"002359.SZ",
			"002637.SZ",
			"002388.SZ",
			"002350.SZ",
			"600148.SS",
			"002420.SZ",
			"002239.SZ",
			"002598.SZ",
			"600318.SS",
			"002149.SZ",
			"000663.SZ",
			"002582.SZ",
			"000727.SZ",
			"002139.SZ",
			"002169.SZ",
			"002014.SZ",
			"000952.SZ",
			"603889.SS",
			"600731.SS",
			"002685.SZ",
			"600975.SS",
			"002639.SZ",
			"002360.SZ",
			"002247.SZ",
			"002427.SZ",
			"002670.SZ",
			"002719.SZ",
			"002159.SZ",
			"002645.SZ",
			"002404.SZ",
			"002054.SZ",
			"002231.SZ",
			"000564.SZ",
			"002402.SZ",
			"002621.SZ",
			"002045.SZ",
			"000890.SZ",
			"002722.SZ",
			"600448.SS",
			"002333.SZ",
			"002403.SZ",
			"600778.SS",
			"002406.SZ",
			"600193.SS",
			"002593.SZ",
			"002694.SZ",
			"002222.SZ",
			"002272.SZ",
			"600543.SS",
			"002053.SZ",
			"002587.SZ",
			"600865.SS",
			"002314.SZ",
			"600712.SS",
			"002090.SZ",
			"600540.SS",
			"603333.SS",
			"002579.SZ",
			"002291.SZ",
			"002286.SZ",
			"000835.SZ",
			"002499.SZ",
			"600202.SS",
			"002381.SZ",
			"002397.SZ",
			"000798.SZ",
			"002708.SZ",
			"002606.SZ",
			"600985.SS",
			"002243.SZ",
			"000070.SZ",
			"002377.SZ",
			"600345.SS",
			"603988.SS",
			"600379.SS",
			"002548.SZ",
			"600107.SS",
			"002026.SZ",
			"600128.SS",
			"002258.SZ",
			"600561.SS",
			"002012.SZ",
			"000812.SZ",
			"600400.SS",
			"002132.SZ",
			"600257.SS",
			"002101.SZ",
			"600791.SS",
			"002656.SZ",
			"002144.SZ",
			"002691.SZ",
			"002370.SZ",
			"600476.SS",
			"000573.SZ",
			"002235.SZ",
			"600693.SS",
			"002661.SZ",
			"002674.SZ",
			"002576.SZ",
			"000713.SZ",
			"002514.SZ",
			"600512.SS",
			"002655.SZ",
			"002659.SZ",
			"002166.SZ",
			"603606.SS",
			"002552.SZ",
			"002088.SZ",
			"603002.SS",
			"600861.SS",
			"600218.SS",
			"000715.SZ",
			"000721.SZ",
			"600857.SS",
			"002688.SZ",
			"601007.SS",
			"002730.SZ",
			"600730.SS",
			"002418.SZ",
			"002256.SZ",
			"002524.SZ",
			"600764.SS",
			"002361.SZ",
			"002559.SZ",
			"600810.SS",
			"002487.SZ",
			"002301.SZ",
			"002578.SZ",
			"600529.SS",
			"000957.SZ",
			"002137.SZ",
			"600328.SS",
			"000753.SZ",
			"002182.SZ",
			"002575.SZ",
			"600367.SS",
			"002212.SZ",
			"002253.SZ",
			"002321.SZ",
			"002300.SZ",
			"002684.SZ",
			"002546.SZ",
			"002725.SZ",
			"002260.SZ",
			"002274.SZ",
			"600744.SS",
			"002515.SZ",
			"002110.SZ",
			"002532.SZ",
			"000637.SZ",
			"002451.SZ",
			"002636.SZ",
			"002409.SZ",
			"600249.SS",
			"002584.SZ",
			"000859.SZ",
			"600477.SS",
			"000795.SZ",
			"000948.SZ",
			"600226.SS",
			"002668.SZ",
			"000978.SZ",
			"002003.SZ",
			"000821.SZ",
			"000524.SZ",
			"002443.SZ",
			"002458.SZ",
			"000698.SZ",
			"600785.SS",
			"002278.SZ",
			"002600.SZ",
			"000705.SZ",
			"002355.SZ",
			"002165.SZ",
			"002411.SZ",
			"600229.SS",
			"002316.SZ",
			"002322.SZ",
			"002330.SZ",
			"002502.SZ",
			"002686.SZ",
			"600589.SS",
			"002472.SZ",
			"600470.SS",
			"002623.SZ",
			"002313.SZ",
			"600802.SS",
			"002394.SZ",
			"002457.SZ",
			"002485.SZ",
			"002255.SZ",
			"002094.SZ",
			"600666.SS",
			"600262.SS",
			"002486.SZ",
			"601599.SS",
			"002259.SZ",
			"600838.SS",
			"600222.SS",
			"603306.SS",
			"601116.SS",
			"002362.SZ",
			"002074.SZ",
			"002695.SZ",
			"000619.SZ",
			"600237.SS",
			"002541.SZ",
			"002567.SZ",
			"002206.SZ",
			"002533.SZ",
			"600960.SS",
			"002510.SZ",
			"600272.SS",
			"600692.SS",
			"002115.SZ",
			"002718.SZ",
			"000756.SZ",
			"002328.SZ",
			"000534.SZ",
			"603011.SS",
			"000752.SZ",
			"600283.SS",
			"002631.SZ",
			"000419.SZ",
			"002693.SZ",
			"600297.SS",
			"600995.SS",
			"600360.SS",
			"600303.SS",
			"600327.SS",
			"002644.SZ",
			"600527.SS",
			"002298.SZ",
			"000790.SZ",
			"000701.SZ",
			"600135.SS",
			"002374.SZ",
			"002732.SZ",
			"600530.SS",
			"600475.SS",
			"601113.SS",
			"002331.SZ",
			"600105.SS",
			"000910.SZ",
			"600354.SS",
			"600336.SS",
			"600117.SS",
			"601177.SS",
			"002133.SZ",
			"601996.SS",
			"600505.SS",
			"002407.SZ",
			"601313.SS",
			"002084.SZ",
			"002282.SZ",
			"000608.SZ",
			"603399.SS",
			"603099.SS",
			"002017.SZ",
			"600258.SS",
			"002616.SZ",
			"000819.SZ",
			"002172.SZ",
			"002709.SZ",
			"002613.SZ",
			"002721.SZ",
			"002692.SZ",
			"002571.SZ",
			"600127.SS",
			"601011.SS",
			"603998.SS",
			"002189.SZ",
			"600461.SS",
			"000153.SZ",
			"000700.SZ",
			"002211.SZ",
			"600116.SS",
			"002442.SZ",
			"600896.SS",
			"002264.SZ",
			"002175.SZ",
			"600103.SS",
			"002706.SZ",
			"002597.SZ",
			"002046.SZ",
			"002126.SZ",
			"002712.SZ",
			"000591.SZ",
			"600966.SS",
			"000599.SZ",
			"002356.SZ",
			"002733.SZ",
			"600531.SS",
			"002107.SZ",
			"002413.SZ",
			"002511.SZ",
			"002220.SZ",
			"002545.SZ",
			"000868.SZ",
			"000551.SZ",
			"002526.SZ",
			"600822.SS",
			"002601.SZ",
			"002348.SZ",
			"000782.SZ",
			"002717.SZ",
			"000530.SZ",
			"002366.SZ",
			"002197.SZ",
			"002641.SZ",
			"002067.SZ",
			"002448.SZ",
			"601137.SS",
			"600333.SS",
			"000026.SZ",
			"600055.SS",
			"002483.SZ",
			"000687.SZ",
			"600113.SS",
			"600697.SS",
			"002382.SZ",
			"000554.SZ",
			"600592.SS",
			"600679.SS",
			"603688.SS",
			"002246.SZ",
			"600172.SS",
			"000609.SZ",
			"002227.SZ",
			"600405.SS",
			"002473.SZ",
			"002363.SZ",
			"002068.SZ",
			"002675.SZ",
			"000096.SZ",
			"000428.SZ",
			"002096.SZ",
			"002232.SZ",
			"600976.SS",
			"002728.SZ",
			"000584.SZ",
			"002398.SZ",
			"000797.SZ",
			"002135.SZ",
			"002666.SZ",
			"002425.SZ",
			"002617.SZ",
			"600192.SS",
			"600231.SS",
			"002438.SZ",
			"600363.SS",
			"600378.SS",
			"002288.SZ",
			"002339.SZ",
			"002628.SZ",
			"002178.SZ",
			"002207.SZ",
			"600081.SS",
			"002566.SZ",
			"600361.SS",
			"002364.SZ",
			"600621.SS",
			"600620.SS",
			"002604.SZ",
			"002643.SZ",
			"600479.SS",
			"600191.SS",
			"002187.SZ",
			"601798.SS",
			"002033.SZ",
			"002671.SZ",
			"002263.SZ",
			"002035.SZ",
			"002039.SZ",
			"002412.SZ",
			"002535.SZ",
			"603003.SS",
			"002245.SZ",
			"002586.SZ",
			"600708.SS",
			"002622.SZ",
			"600119.SS",
			"002401.SZ",
			"002010.SZ",
			"600973.SS",
			"000523.SZ",
			"000708.SZ",
			"002731.SZ",
			"002346.SZ",
			"002383.SZ",
			"601799.SS",
			"002060.SZ",
			"002521.SZ",
			"002638.SZ",
			"002158.SZ",
			"002042.SZ",
			"601199.SS",
			"002083.SZ",
			"600285.SS",
			"002478.SZ",
			"002453.SZ",
			"002349.SZ",
			"600288.SS",
			"002386.SZ",
			"600439.SS",
			"600798.SS",
			"002538.SZ",
			"600979.SS",
			"600590.SS",
			"000404.SZ",
			"600321.SS",
			"601518.SS",
			"600078.SS",
			"600969.SS",
			"601789.SS",
			"600523.SS",
			"002592.SZ",
			"002449.SZ",
			"002516.SZ",
			"000949.SZ",
			"600630.SS",
			"600260.SS",
			"600368.SS",
			"000936.SZ",
			"002218.SZ",
			"002229.SZ",
			"002445.SZ",
			"002059.SZ",
			"600469.SS",
			"603518.SS",
			"603008.SS",
			"000065.SZ",
			"002612.SZ",
			"600789.SS",
			"002320.SZ",
			"002713.SZ",
			"002297.SZ",
			"600830.SS",
			"600668.SS",
			"600467.SS",
			"002123.SZ",
			"002198.SZ",
			"002148.SZ",
			"600186.SS",
			"600268.SS",
			"002228.SZ",
			"601890.SS",
			"000915.SZ",
			"002055.SZ",
			"600480.SS",
			"002369.SZ",
			"002154.SZ",
			"002726.SZ",
			"000811.SZ",
			"002214.SZ",
			"600965.SS",
			"002387.SZ",
			"002488.SZ",
			"002062.SZ",
			"002284.SZ",
			"002279.SZ",
			"600459.SS",
			"002020.SZ",
			"002677.SZ",
			"000407.SZ",
			"002518.SZ",
			"002452.SZ",
			"002618.SZ",
			"000045.SZ",
			"002495.SZ",
			"002335.SZ",
			"002184.SZ",
			"601616.SS",
			"002581.SZ",
			"002689.SZ",
			"600834.SS",
			"002021.SZ",
			"002283.SZ",
			"600616.SS",
			"002700.SZ",
			"000886.SZ",
			"002468.SZ",
			"002108.SZ",
			"002469.SZ",
			"002476.SZ",
			"002554.SZ",
			"002121.SZ",
			"601579.SS",
			"600310.SS",
			"002635.SZ",
			"002543.SZ",
			"600326.SS",
			"000159.SZ",
			"002611.SZ",
			"002484.SZ",
			"600387.SS",
			"601388.SS",
			"002111.SZ",
			"600162.SS",
			"000532.SZ",
			"000521.SZ",
			"002614.SZ",
			"600641.SS",
			"002226.SZ",
			"600238.SS",
			"002116.SZ",
			"000597.SZ",
			"600114.SS",
			"002561.SZ",
			"600836.SS",
			"002391.SZ",
			"002097.SZ",
			"000888.SZ",
			"600382.SS",
			"002609.SZ",
			"002446.SZ",
			"600665.SS",
			"600888.SS",
			"600126.SS",
			"603588.SS",
			"601677.SS",
			"002519.SZ",
			"002337.SZ",
			"600624.SS",
			"002334.SZ",
			"002100.SZ",
			"600684.SS",
			"000989.SZ",
			"000589.SZ",
			"600322.SS",
			"000731.SZ",
			"002080.SZ",
			"002171.SZ",
			"002091.SZ",
			"002156.SZ",
			"002009.SZ",
			"600533.SS",
			"002441.SZ",
			"002079.SZ",
			"002093.SZ",
			"600389.SS",
			"601208.SS",
			"002037.SZ",
			"002528.SZ",
			"600686.SS",
			"600652.SS",
			"600723.SS",
			"603168.SS",
			"600290.SS",
			"600133.SS",
			"002177.SZ",
			"600106.SS",
			"002649.SZ",
			"600287.SS",
			"600397.SS",
			"603167.SS",
			"600308.SS",
			"002389.SZ",
			"002324.SZ",
			"002460.SZ",
			"600661.SS",
			"600846.SS",
			"002574.SZ",
			"000903.SZ",
			"600197.SS",
			"002338.SZ",
			"600987.SS",
			"002434.SZ",
			"600571.SS",
			"002650.SZ",
			"600211.SS",
			"600035.SS",
			"600501.SS",
			"600305.SS",
			"002564.SZ",
			"002699.SZ",
			"600963.SS",
			"002326.SZ",
			"002547.SZ",
			"002238.SZ",
			"000627.SZ",
			"002351.SZ",
			"600628.SS",
			"002471.SZ",
			"002332.SZ",
			"002509.SZ",
			"000151.SZ",
			"000916.SZ",
			"600289.SS",
			"002716.SZ",
			"600982.SS",
			"603123.SS",
			"600239.SS",
			"002016.SZ",
			"002664.SZ",
			"600626.SS",
			"600682.SS",
			"600488.SS",
			"002565.SZ",
			"002224.SZ",
			"600756.SS",
			"002454.SZ",
			"600112.SS",
			"002327.SZ",
			"002167.SZ",
			"600558.SS",
			"002539.SZ",
			"600227.SS",
			"601999.SS",
			"603368.SS",
			"600279.SS",
			"600121.SS",
			"600586.SS",
			"002507.SZ",
			"002520.SZ",
			"002254.SZ",
			"603128.SS",
			"600396.SS",
			"600502.SS",
			"002393.SZ",
			"002342.SZ",
			"600088.SS",
			"000823.SZ",
			"002549.SZ",
			"603126.SS",
			"002186.SZ",
			"600246.SS",
			"601188.SS",
			"600742.SS",
			"600449.SS",
			"002194.SZ",
			"000043.SZ",
			"002225.SZ",
			"000973.SZ",
			"002157.SZ",
			"600797.SS",
			"002341.SZ",
			"600824.SS",
			"002161.SZ",
			"002683.SZ",
			"000938.SZ",
			"600420.SS",
			"600330.SS",
			"002070.SZ",
			"000889.SZ",
			"603100.SS",
			"600351.SS",
			"002610.SZ",
			"600651.SS",
			"600468.SS",
			"002215.SZ",
			"000759.SZ",
			"600750.SS",
			"600298.SS",
			"600526.SS",
			"600736.SS",
			"002497.SZ",
			"002556.SZ",
			"600510.SS",
			"002640.SZ",
			"600619.SS",
			"600337.SS",
			"002118.SZ",
			"002099.SZ",
			"000429.SZ",
			"601700.SS",
			"000301.SZ",
			"002052.SZ",
			"603018.SS",
			"002025.SZ",
			"002630.SZ",
			"002467.SZ",
			"600667.SS",
			"600702.SS",
			"002531.SZ",
			"600814.SS",
			"600491.SS",
			"600653.SS",
			"000601.SZ",
			"000762.SZ",
			"002557.SZ",
			"002462.SZ",
			"002296.SZ",
			"002542.SZ",
			"002527.SZ",
			"002315.SZ",
			"002711.SZ",
			"600713.SS",
			"002138.SZ",
			"000417.SZ",
			"600563.SS",
			"603366.SS",
			"002489.SZ",
			"002550.SZ",
			"002705.SZ",
			"002568.SZ",
			"600496.SS",
			"002436.SZ",
			"002307.SZ",
			"000733.SZ",
			"002474.SZ",
			"002273.SZ",
			"002697.SZ",
			"000996.SZ",
			"002376.SZ",
			"600790.SS",
			"002095.SZ",
			"600537.SS",
			"002479.SZ",
			"603111.SS",
			"600993.SS",
			"000422.SZ",
			"002029.SZ",
			"601218.SS",
			"002261.SZ",
			"000990.SZ",
			"002605.SZ",
			"603456.SS",
			"600195.SS",
			"600884.SS",
			"600482.SS",
			"000616.SZ",
			"600829.SS",
			"000919.SZ",
			"601678.SS",
			"002308.SZ",
			"000158.SZ",
			"600559.SS",
			"002372.SZ",
			"002504.SZ",
			"600577.SS",
			"002626.SZ",
			"002496.SZ",
			"000029.SZ",
			"600220.SS",
			"600278.SS",
			"002305.SZ",
			"601028.SS",
			"002447.SZ",
			"002583.SZ",
			"000966.SZ",
			"600507.SS",
			"601126.SS",
			"600063.SS",
			"002589.SZ",
			"600596.SS",
			"002585.SZ",
			"002130.SZ",
			"002317.SZ",
			"002345.SZ",
			"000900.SZ",
			"002707.SZ",
			"600460.SS",
			"600171.SS",
			"002277.SZ",
			"000426.SZ",
			"600897.SS",
			"000078.SZ",
			"600676.SS",
			"601636.SS",
			"000636.SZ",
			"603001.SS",
			"600251.SS",
			"603308.SS",
			"002031.SZ",
			"000016.SZ",
			"002512.SZ",
			"600059.SS",
			"002293.SZ",
			"000850.SZ",
			"000875.SZ",
			"600129.SS",
			"600210.SS",
			"600110.SS",
			"000987.SZ",
			"002430.SZ",
			"002480.SZ",
			"600843.SS",
			"600054.SS",
			"002534.SZ",
			"600416.SS",
			"000042.SZ",
			"002237.SZ",
			"600456.SS",
			"002540.SZ",
			"002117.SZ",
			"002551.SZ",
			"601566.SS",
			"002023.SZ",
			"002329.SZ",
			"601010.SS",
			"600777.SS",
			"600200.SS",
			"600677.SS",
			"600184.SS",
			"002657.SZ",
			"002491.SZ",
			"603166.SS",
			"002481.SZ",
			"002089.SZ",
			"002281.SZ",
			"002658.SZ",
			"000066.SZ",
			"600291.SS",
			"600438.SS",
			"002176.SZ",
			"000829.SZ",
			"002048.SZ",
			"000090.SZ",
			"601567.SS",
			"000930.SZ",
			"002170.SZ",
			"000926.SZ",
			"002168.SZ",
			"002028.SZ",
			"000055.SZ",
			"600255.SS",
			"600545.SS",
			"601008.SS",
			"002421.SZ",
			"002577.SZ",
			"600780.SS",
			"600794.SS",
			"002276.SZ",
			"600486.SS",
			"002216.SZ",
			"000837.SZ",
			"002302.SZ",
			"002482.SZ",
			"600132.SS",
			"600487.SS",
			"601965.SS",
			"000969.SZ",
			"600654.SS",
			"002210.SZ",
			"000830.SZ",
			"600990.SS",
			"601339.SS",
			"603609.SS",
			"600569.SS",
			"002151.SZ",
			"002463.SZ",
			"002140.SZ",
			"000501.SZ",
			"601222.SS",
			"000525.SZ",
			"600284.SS",
			"002392.SZ",
			"600458.SS",
			"600141.SS",
			"600819.SS",
			"000553.SZ",
			"000667.SZ",
			"000810.SZ",
			"600508.SS",
			"000665.SZ",
			"600481.SS",
			"600602.SS",
			"002703.SZ",
			"600551.SS",
			"600261.SS",
			"600122.SS",
			"002681.SZ",
			"002477.SZ",
			"600826.SS",
			"002011.SZ",
			"000905.SZ",
			"600640.SS",
			"600280.SS",
			"600872.SS",
			"601058.SS",
			"600366.SS",
			"002433.SZ",
			"000099.SZ",
			"000852.SZ",
			"002251.SZ",
			"002367.SZ",
			"002384.SZ",
			"601100.SS",
			"002624.SZ",
			"002737.SZ",
			"600422.SS",
			"002522.SZ",
			"000828.SZ",
			"000807.SZ",
			"002242.SZ",
			"600720.SS",
			"600300.SS",
			"600815.SS",
			"002432.SZ",
			"600724.SS",
			"002104.SZ",
			"002325.SZ",
			"002185.SZ",
			"000516.SZ",
			"002461.SZ",
			"600971.SS",
			"600782.SS",
			"002498.SZ",
			"600073.SS",
			"000739.SZ",
			"601015.SS",
			"600997.SS",
			"600726.SS",
			"600662.SS",
			"600978.SS",
			"002280.SZ",
			"601777.SS",
			"600509.SS",
			"002106.SZ",
			"600650.SS",
			"002064.SZ",
			"002073.SZ",
			"002191.SZ",
			"002056.SZ",
			"000877.SZ",
			"002122.SZ",
			"002662.SZ",
			"002131.SZ",
			"002233.SZ",
			"002287.SZ",
			"600478.SS",
			"600020.SS",
			"600638.SS",
			"002651.SZ",
			"000882.SZ",
			"002408.SZ",
			"000531.SZ",
			"002371.SZ",
			"002063.SZ",
			"002663.SZ",
			"600064.SS",
			"002078.SZ",
			"000680.SZ",
			"600983.SS",
			"002572.SZ",
			"600391.SS",
			"600120.SS",
			"002428.SZ",
			"000861.SZ",
			"600841.SS",
			"000006.SZ",
			"603005.SS",
			"601886.SS",
			"002724.SZ",
			"002396.SZ",
			"000410.SZ",
			"600168.SS",
			"002303.SZ",
			"600805.SS",
			"600206.SS",
			"600747.SS",
			"002646.SZ",
			"600761.SS",
			"600295.SS",
			"600067.SS",
			"601908.SS",
			"600687.SS",
			"002431.SZ",
			"002648.SZ",
			"002262.SZ",
			"002249.SZ",
			"603077.SS",
			"000089.SZ",
			"002698.SZ",
			"000519.SZ",
			"002426.SZ",
			"600061.SS",
			"002595.SZ",
			"600525.SS",
			"002180.SZ",
			"002318.SZ",
			"000541.SZ",
			"600201.SS",
			"600325.SS",
			"600812.SS",
			"000062.SZ",
			"002390.SZ",
			"601003.SS",
			"002155.SZ",
			"600729.SS",
			"600216.SS",
			"600595.SS",
			"002071.SZ",
			"002378.SZ",
			"601233.SS",
			"002503.SZ",
			"600012.SS",
			"600859.SS",
			"600601.SS",
			"603555.SS",
			"601101.SS",
			"002085.SZ",
			"600704.SS",
			"600323.SS",
			"603169.SS",
			"002508.SZ",
			"600426.SS",
			"002665.SZ",
			"002022.SZ",
			"002466.SZ",
			"600033.SS",
			"600851.SS",
			"002050.SZ",
			"002312.SZ",
			"000021.SZ",
			"000939.SZ",
			"000988.SZ",
			"002714.SZ",
			"000860.SZ",
			"002269.SZ",
			"002727.SZ",
			"002309.SZ",
			"600236.SS",
			"000652.SZ",
			"002092.SZ",
			"002032.SZ",
			"603766.SS",
			"002275.SZ",
			"002416.SZ",
			"000777.SZ",
			"002244.SZ",
			"002179.SZ",
			"600567.SS",
			"002439.SZ",
			"000690.SZ",
			"000901.SZ",
			"600584.SS",
			"002419.SZ",
			"002240.SZ",
			"002030.SZ",
			"000848.SZ",
			"002190.SZ",
			"002005.SZ",
			"600380.SS",
			"002588.SZ",
			"601311.SS",
			"002181.SZ",
			"002642.SZ",
			"600825.SS",
			"601012.SS",
			"600770.SS",
			"002041.SZ",
			"600183.SS",
			"002444.SZ",
			"000661.SZ",
			"603328.SS",
			"002221.SZ",
			"600409.SS",
			"600521.SS",
			"000726.SZ",
			"600850.SS",
			"002285.SZ",
			"600618.SS",
			"002299.SZ",
			"600125.SS",
			"002204.SZ",
			"600062.SS",
			"600580.SS",
			"600273.SS",
			"600151.SS",
			"002219.SZ",
			"002004.SZ",
			"600343.SS",
			"600880.SS",
			"600123.SS",
			"600269.SS",
			"600160.SS",
			"000932.SZ",
			"600483.SS",
			"600575.SS",
			"600557.SS",
			"601519.SS",
			"600006.SS",
			"600138.SS",
			"002340.SZ",
			"000488.SZ",
			"600803.SS",
			"002267.SZ",
			"002690.SZ",
			"002368.SZ",
			"002672.SZ",
			"002250.SZ",
			"603188.SS",
			"600565.SS",
			"600967.SS",
			"000612.SZ",
			"002429.SZ",
			"002414.SZ",
			"000897.SZ",
			"600572.SS",
			"601717.SS",
			"600446.SS",
			"601515.SS",
			"600331.SS",
			"002400.SZ",
			"002701.SZ",
			"600004.SS",
			"002678.SZ",
			"600587.SS",
			"600175.SS",
			"000666.SZ",
			"000547.SZ",
			"603019.SS",
			"002354.SZ",
			"002266.SZ",
			"600499.SS",
			"600623.SS",
			"601038.SS",
			"600410.SS",
			"002501.SZ",
			"002311.SZ",
			"600594.SS",
			"600517.SS",
			"002223.SZ",
			"600522.SS",
			"600161.SS",
			"002174.SZ",
			"002268.SZ",
			"600292.SS",
			"002493.SZ",
			"600176.SS",
			"002405.SZ",
			"000543.SZ",
			"600428.SS",
			"600079.SS",
			"002203.SZ",
			"002602.SZ",
			"600096.SS",
			"002440.SZ",
			"600748.SS",
			"002271.SZ",
			"002555.SZ",
			"002358.SZ",
			"603369.SS",
			"600635.SS",
			"600433.SS",
			"600694.SS",
			"600673.SS",
			"600436.SS",
			"600881.SS",
			"000528.SZ",
			"601666.SS",
			"601369.SS",
			"601226.SS",
			"600017.SS",
			"002544.SZ",
			"000022.SZ",
			"000758.SZ",
			"601001.SS",
			"002049.SZ",
			"603699.SS",
			"000513.SZ",
			"000997.SZ",
			"002183.SZ",
			"600970.SS",
			"002573.SZ",
			"600399.SS",
			"600582.SS",
			"600270.SS",
			"600765.SS",
			"600511.SS",
			"002195.SZ",
			"600158.SS",
			"600060.SS",
			"600388.SS",
			"601801.SS",
			"600643.SS",
			"002128.SZ",
			"000563.SZ",
			"000031.SZ",
			"600498.SS",
			"603806.SS",
			"601002.SS",
			"600566.SS",
			"600007.SS",
			"600157.SS",
			"600037.SS",
			"600917.SS",
			"600418.SS",
			"000582.SZ",
			"000970.SZ",
			"600811.SS",
			"600801.SS",
			"000961.SZ",
			"600495.SS",
			"600867.SS",
			"601588.SS",
			"600879.SS",
			"600536.SS",
			"600267.SS",
			"601139.SS",
			"002143.SZ",
			"002603.SZ",
			"600039.SS",
			"002001.SZ",
			"002570.SZ",
			"601107.SS",
			"000975.SZ",
			"600056.SS",
			"600664.SS",
			"600021.SS",
			"002018.SZ",
			"002410.SZ",
			"601929.SS",
			"002008.SZ",
			"600312.SS",
			"002375.SZ",
			"600612.SS",
			"600655.SS",
			"600219.SS",
			"600823.SS",
			"000028.SZ",
			"000685.SZ",
			"002437.SZ",
			"600166.SS",
			"000839.SZ",
			"000401.SZ",
			"600143.SS",
			"002013.SZ",
			"000671.SZ",
			"002344.SZ",
			"000786.SZ",
			"600787.SS",
			"600548.SS",
			"002038.SZ",
			"600108.SS",
			"000600.SZ",
			"600435.SS",
			"601016.SS",
			"000012.SZ",
			"002653.SZ",
			"002310.SZ",
			"600277.SS",
			"002292.SZ",
			"601000.SS",
			"600058.SS",
			"600755.SS",
			"600611.SS",
			"600252.SS",
			"600835.SS",
			"000088.SZ",
			"601608.SS",
			"002465.SZ",
			"601258.SS",
			"002424.SZ",
			"002007.SZ",
			"600497.SS",
			"600718.SS",
			"002456.SZ",
			"000060.SZ",
			"000998.SZ",
			"600395.SS",
			"000977.SZ",
			"600809.SS",
			"002152.SZ",
			"000960.SZ",
			"600316.SS",
			"600022.SS",
			"600754.SS",
			"000878.SZ",
			"002153.SZ",
			"601880.SS",
			"000400.SZ",
			"600895.SS",
			"002399.SZ",
			"600783.SS",
			"002505.SZ",
			"002470.SZ",
			"002422.SZ",
			"600169.SS",
			"002051.SZ",
			"600348.SS",
			"601216.SS",
			"002230.SZ",
			"600597.SS",
			"600839.SS",
			"600649.SS",
			"000050.SZ",
			"600500.SS",
			"000959.SZ",
			"600528.SS",
			"002129.SZ",
			"601168.SS",
			"600639.SS",
			"002385.SZ",
			"600038.SS",
			"000999.SZ",
			"000061.SZ",
			"002563.SZ",
			"000793.SZ",
			"000729.SZ",
			"000778.SZ",
			"600376.SS",
			"000937.SZ",
			"000559.SZ",
			"000963.SZ",
			"002475.SZ",
			"600315.SS",
			"002294.SZ",
			"603000.SS",
			"600098.SS",
			"000869.SZ",
			"000917.SZ",
			"600350.SS",
			"600660.SS",
			"000712.SZ",
			"000423.SZ",
			"601718.SS",
			"000800.SZ",
			"600804.SS",
			"600177.SS",
			"600100.SS",
			"002236.SZ",
			"000983.SZ",
			"600008.SS",
			"600820.SS",
			"600307.SS",
			"600863.SS",
			"601699.SS",
			"002065.SZ",
			"600588.SS",
			"000581.SZ",
			"601928.SS",
			"600549.SS",
			"002450.SZ",
			"600271.SS",
			"600547.SS",
			"601933.SS",
			"000568.SZ",
			"600717.SS",
			"600153.SS",
			"000876.SZ",
			"600578.SS",
			"002353.SZ",
			"600642.SS",
			"600085.SS",
			"000027.SZ",
			"000630.SZ",
			"002081.SZ",
			"600998.SS",
			"601872.SS",
			"601969.SS",
			"601098.SS",
			"000825.SZ",
			"002146.SZ",
			"600352.SS",
			"601958.SS",
			"601877.SS",
			"600739.SS",
			"600317.SS",
			"600827.SS",
			"000425.SZ",
			"600808.SS",
			"600026.SS",
			"000623.SZ",
			"600489.SS",
			"601333.SS",
			"600320.SS",
			"601231.SS",
			"600066.SS",
			"600118.SS",
			"600570.SS",
			"601118.SS",
			"000539.SZ",
			"000883.SZ",
			"000792.SZ",
			"600415.SS",
			"600518.SS",
			"600332.SS",
			"600406.SS",
			"601106.SS",
			"600685.SS",
			"600648.SS",
			"600377.SS",
			"000402.SZ",
			"600266.SS",
			"002241.SZ",
			"600009.SS",
			"002202.SZ",
			"600170.SS",
			"000686.SZ",
			"601179.SS",
			"600741.SS",
			"600089.SS",
			"002500.SZ",
			"000709.SZ",
			"600875.SS",
			"600221.SS",
			"600637.SS",
			"600535.SS",
			"601158.SS",
			"600068.SS",
			"601888.SS",
			"601009.SS",
			"600256.SS",
			"601607.SS",
			"603993.SS",
			"002673.SZ",
			"000046.SZ",
			"600398.SS",
			"600674.SS",
			"600583.SS",
			"601117.SS",
			"600688.SS",
			"600309.SS",
			"601992.SS",
			"600196.SS",
			"601099.SS",
			"000768.SZ",
			"600029.SS",
			"002142.SZ",
			"600383.SS",
			"000157.SZ",
			"000338.SZ",
			"601238.SS",
			"600276.SS",
			"600600.SS",
			"600690.SS",
			"601866.SS",
			"000039.SZ",
			"600208.SS",
			"601018.SS",
			"000069.SZ",
			"603288.SS",
			"601555.SS",
			"002252.SZ",
			"600027.SS",
			"000063.SZ",
			"600111.SS",
			"600362.SS",
			"600188.SS",
			"600010.SS",
			"000538.SZ",
			"002024.SZ",
			"601225.SS",
			"000895.SZ",
			"600663.SS",
			"601899.SS",
			"600031.SS",
			"000625.SZ",
			"601377.SS",
			"601669.SS",
			"000858.SZ",
			"002736.SZ",
			"601600.SS",
			"600023.SS",
			"002304.SZ",
			"600795.SS",
			"601766.SS",
			"002415.SZ",
			"601991.SS",
			"601898.SS",
			"002594.SZ",
			"601618.SS",
			"601788.SS",
			"601808.SS",
			"601111.SS",
			"600050.SS",
			"601727.SS",
			"000651.SZ",
			"601169.SS",
			"600019.SS",
			"000333.SZ",
			"601901.SS",
			"600048.SS",
			"600585.SS",
			"600015.SS",
			"601633.SS",
			"600485.SS",
			"600011.SS",
			"601688.SS",
			"600018.SS",
			"000002.SZ",
			"601336.SS",
			"601006.SS",
			"600999.SS",
			"601989.SS",
			"600900.SS",
			"000001.SZ",
			"601186.SS",
			"601390.SS",
			"600519.SS",
			"601668.SS",
			"601800.SS",
			"601818.SS",
			"600104.SS",
			"600000.SS",
			"601601.SS",
			"601166.SS",
			"600016.SS",
			"600030.SS",
			"601998.SS",
			"601088.SS",
			"600036.SS",
			"601328.SS",
			"601318.SS",
			"600028.SS",
			"601628.SS",
			"601988.SS",
			"601288.SS",
			"601939.SS",
			"601398.SS",
			"601857.SS"
		]

for code in code_list:
	url = "http://127.0.0.1/test/stock/import/"+code
	
	conn = httplib.HTTPConnection("127.0.0.1")
	conn.request(method="GET",url=url) 
	response = conn.getresponse()
	res= response.read()
	print res