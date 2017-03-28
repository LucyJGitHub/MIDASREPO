000100151020     H DEBUG
000101151020     H DFTACTGRP(*NO)
000102151020     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
000103151020      *****************************************************************
000104151020/*STD *  RPGBASEBND                                                   *
000105151020/*EXI *  TEXT('Midas FT Unlock Payment Screen')
000106151020      *****************************************************************
000107151020      *                                                               *
000108151020      *  Midas - Fund Transfer Module                                 *
000109151020      *                                                               *
000110151020      *  FT000400R - FT Unlock Payment Screen                         *
000111151020      *                                                               *
000112151020      *  (c) Misys International Banking Systems Ltd. 2015            *
000113151020      *                                                               *
000114170316      *  Last Amend No. MD044750           Date 15Mar17               *
000115170315      *  Prev Amend No. MD024626 *CREATE   Date 15Oct15               *
000116151020      *                                                               *
000117151020      *****************************************************************
000118151020      *                                                               *
000119170316      *  MD044750 - Incorrect functionality of unlock payments menus  *
000120151020      *  MD024626 - No access to Payment after expired or closed      *
000121151020      *            session. New screen created to unlock payment.     *
000122151020      *                                                               *
000123151020      *****************************************************************
000124151020     FFT000400DFCF   E             WORKSTN
000125151020     FOTPAY     IF   E           K DISK    PREFIX(OT_)
000126151020     FINPAY     IF   E           K DISK    PREFIX(IN_)
000127151020
000128151020      **---------------------------------------------------------------
000129151020      ** The following /COPY line includes all the defined fields in
000130151020      ** the Program Status Data Structures.  They have meaningful
000131151020      ** names, prefixed by 'PS'.
000132151020     D/COPY ZACPYSRC,PSDS
000133151020     D/COPY ZACPYSRC,STD_D_SPEC
000134151020
000135151020      ** +--------------------------------------+
000136151020      ** ¦ Program Prototypes                   ¦
000137151020      ** ¦ ==================                   ¦
000138151020      ** +--------------------------------------+
000139151020     D Main            pr                  extpgm('FT000400R')
000140151020     D  modeOperation                10a   const options(*nopass)
000141151020     D Main            pi
000142151020     D  modeOperation                10a   const options(*nopass)
000143151020
000144151020     D  UnlockRoutine  pr                  extpgm('FTC000400')
000145151020     D    pReturnCode                 7a
000146151020     D    pDataArea                  10a
000147151020     D    pUser                      10a
000148151020     D    pMode                      10a
000149151020
000150151020      ** +--------------------------------------+
000151151020      ** ¦ Manually included D-specs            ¦
000152151020      ** ¦ =========================            ¦
000153151020      ** +--------------------------------------+
000154151020     D SDSTAT        e ds                  extname(SDSTAT) dtaara(SDSTAT)
000155151020     D RUNDAT        e ds                  extname(RUNDAT) dtaara(RUNDAT)
000156151020
000157151020      ** +--------------------------------------+
000158151020      ** ¦ Constants declaration                ¦
000159151020      ** ¦ =====================                ¦
000160151020      ** +--------------------------------------+
000161151020
000162151020      ** +--------------------------------------+
000163151020      ** ¦ Variable declaration                 ¦
000164151020      ** ¦ ====================                 ¦
000165151020      ** +--------------------------------------+
000166151020     D  modeOP         s             10a
000167151020     D  paymentRef     s             10a
000168151020     D  dataAreaName   s             10a   inz(*blanks)
000169151020     D  paymentType    s              2a   inz(*blanks)
000170151020     D  isExit         s               n   inz(*off)
000171151020     D  isFound        s               n   inz(*off)
000172151020     D  isValidPREF    s               n   inz(*off)
000173151020     D  isValidUSER    s               n   inz(*off)
000174151020     D  MessageID      s              7a   inz(*blanks)
000175151020     D  CommandStr     s            200a   inz(*blanks)
000176151020
000177151020      ** +--------------------------------------+
000178151020      ** ¦ Array declaration                    ¦
000179151020      ** ¦ ==================                   ¦
000180151020      ** +--------------------------------------+
000181151020
000182151020      /free
000183151020
000184151020       // ** +--- Start of Main processing -----------------------------------+
000185151020       // ** ¦                                                                ¦
000186151020       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000187151020       // ** ¦ executed at program activation.                                ¦
000188151020       // ** ¦                                                                ¦
000189151020       // ** +----------------------------------------------------------------+
000190151020
000191151020                   user = psuser;
000192151020                   job = psjobname;
000193151020                   in RunDat;
000194151020                   date = AGMRDT;
000195151020
000196151020                   dow not (isExit);
000197151020
000198151020                      if modeOperation = '*SAME';
000199151020                         *In60 = *On;
000200151020                         suser = psuser;
000201151020                      endif;
000202151020                      exfmt FT000400D0;
000203151020
000204170316                      exsr validatePaymentReference;                                      //MD044750
000205170316                      exsr validateUserName;                                              //MD044750
000206170315
000207151020                      select;
000208151020                         when *In03 = *On;
000209151020                            Leave;
000210151020                         when *In10 = *On;
000211170316                         if isValidPREF and isValidUSER;                                  //MD044750
000212170315                            exsr UnlockPayment;
000213170316                         endif;                                                           //MD044750
000214170315
000215170316      //                 other;                                                           //MD044750
000216170316      //                    exsr validatePaymentReference;                                //MD044750
000217170316      //                    exsr validateUserName;                                        //MD044750
000218170316      //                    if isValidPREF and isValidUSER;                               //MD044750
000219170316      //                       *In64 = *On;                                               //MD044750
000220170316      //                    else;                                                         //MD044750
000221170316      //                       *In64 = *Off;                                              //MD044750
000222170316      //                    endif;                                                        //MD044750
000223151020                      endsl;
000224151020                   enddo;
000225151020
000226151020                   *Inlr = *On;
000227151020                   return;
000228151020
000229151020       //*************************************************************
000230151020       //                                                            *
000231151020       // validatePaymentReference                                   *
000232151020       // ========================                                   *
000233151020       //                                                            *
000234151020       // Called by: Main Processing                                 *
000235151020       //                                                            *
000236151020       // Calls: *none                                               *
000237151020       //                                                            *
000238151020       //*************************************************************
000239151020
000240151020       begsr validatePaymentReference;
000241151020
000242151020       //Check if payment reference is entered
000243151020                   *In11 = *Off;
000244151020                   isValidPREF = *On;
000245151020                   if spref = *Blanks;
000246151020                      ermsg = 'Payment reference must be entered';
000247151020                      exsr setupPError;
000248170316                      LEAVESR;                                                            //MD044750
000249151020                   endif;
000250151020
000251151020                   paymentType = %subst(spref:12:2);
000252151020
000253151020       //Check if payment reference exist
000254151020                   select;
000255151020                      when paymentType = 'OP';
000256151020                           paymentRef = 'O' + %subst(spref:3:9);
000257151020                           chain (spref) otpay;
000258151020                           eval isFound = %found;
000259151020                           if not(isFound);
000260151020                              ermsg = 'Payment reference does not exist in ' +
000261151020                                      'outgoing payments file';
000262151020                              exsr setupPError;
000263151020                           endif;
000264151020
000265151020                      when paymentType = 'IN';
000266151020                           paymentRef = 'I' + %subst(spref:3:9);
000267151020                           chain (spref) inpay;
000268151020                           eval isFound = %found;
000269151020                           if not(isFound);
000270151020                              ermsg = 'Payment reference does not exist in ' +
000271151020                                      'incoming payments file';
000272151020                              exsr setupPError;
000273151020                           endif;
000274151020                      other;
000275151020                         ermsg = 'Invalid payment details is entered';
000276151020                         exsr setupPError;
000277151020                   endsl;
000278151020
000279151020                   if isValidPREF;
000280151020                      erMsg = *blanks;
000281151020                   endif;
000282151020
000283151020       endsr;
000284151020       //*************************************************************
000285151020       //                                                            *
000286151020       // unlockPayment                                              *
000287151020       // =============                                              *
000288151020       //                                                            *
000289151020       // Called by: Main Processing                                 *
000290151020       //                                                            *
000291151020       // Calls: *none                                               *
000292151020       //                                                            *
000293151020       //*************************************************************
000294151020
000295151020       begsr unlockPayment;
000296151020
000297151020       // Check if data area exist
000298151020             CommandStr =  'CHKOBJ OBJ(' +
000299151020                            %Trim(paymentRef) + ') ' +
000300151020                            'OBJTYPE(*DTAARA) AUT(*ALL)';
000301151020             exsr SrCommand;
000302151020             if MessageID = 'CPF9801';
000303151020                erMsg = %Trim(spref) + ' is not locked';
000304151020                exsr setupPError;
000305151020                LeaveSR;
000306151020             endif;
000307151020             modeOp = modeOperation;
000308151020
000309151020             callp UnlockRoutine(
000310151020                                  returnCode:
000311151020                                  paymentRef:
000312151020                                  suser:
000313151020                                  modeOp
000314151020                                );
000315151021             if returnCode <> *blanks and returnCode <> '*USER'
000316151022                and returnCode <> '*NONE' and returnCode <> '*NEND';
000317151020                dBkey = *blanks;
000318151020                dBfile = *Blanks;
000319151020                dBase = 002;
000320151020                dBpgm  = 'FTC000400';
000321151020                exsr *pssr;
000322151020             elseif returnCode = '*USER';
000323151021                erMsg = %Trim(suser) +
000324151021                'is not allowed to end job of another user';
000325151020                *In50 = *On;
000326151020                *In11 = *On;
000327151020                LeaveSR;
000328151021             elseif returnCode = '*NONE';
000329151021                erMsg = %Trim(suser) +
000330151021                        ' is not associated with the payment reference '
000331151020                        + spref;
000332151020                *In50 = *On;
000333151020                *In11 = *On;
000334151020                LeaveSR;
000335151022             elseif returnCode = '*NEND';
000336151022                erMsg = 'Job cannot be ended at this time';
000337151022                *In50 = *On;
000338151022                *In11 = *On;
000339151022                LeaveSR;
000340151020             else;
000341151020                erMsg = %Trim(spref) + ' is now unlocked by ' + %Trim(suser);
000342151020                *In50 = *On;
000343151020                spref = *blanks;
000344151020                suser = *blanks;
000345151020             endif;
000346151020
000347151020       endsr;
000348151020
000349151020       //*************************************************************
000350151020       //                                                            *
000351151020       // validateUserName                                           *
000352151020       // ================                                           *
000353151020       //                                                            *
000354151020       // Called by: Main Processing                                 *
000355151020       //                                                            *
000356151020       // Calls: *none                                               *
000357151020       //                                                            *
000358151020       //*************************************************************
000359151020
000360151020       begsr validateUserName;
000361151020
000362151020                   if not(isValidPREF);
000363151020                      LeaveSr;
000364151020                   endif;
000365151020
000366151020                   *In12 = *Off;
000367151020                   isValidUSER = *On;
000368151020                   if suser = *Blanks;
000369151020                      ermsg = 'User name must be entered';
000370151020                      *In50 = *On;
000371151020                      *In12 = *On;
000372151020                      isValidUSER = *Off;
000373151020                      leaveSr;
000374151020                   endif;
000375151020
000376151020                   if isValidUSER;
000377151020                      erMsg = *blanks;
000378151020                   endif;
000379151020
000380151020
000381151020       endsr;
000382151020
000383151020       //*************************************************************
000384151020       /EJECT
000385151020       //*************************************************************
000386151020       //                                                            *
000387151020       // setupPError                                                *
000388151020       //                                                            *
000389151020       // Called by: validatePaymentReference                        *
000390151020       //                                                            *
000391151020       //  Calls: None                                               *
000392151020       //                                                            *
000393151020       //*************************************************************
000394151020
000395151020       begsr setupPError;
000396151020                   *In50 = *On;
000397151020                   *In11 = *On;
000398151020                   isValidPREF = *Off;
000399151020       endsr;
000400151020
000401151020       //*************************************************************
000402151020       /EJECT
000403151020       //*************************************************************
000404151020       //                                                            *
000405151020       // inzsr - Program Initialisation routine                     *
000406151020       //                                                            *
000407151020       // Called by: Main processing                                 *
000408151020       //                                                            *
000409151020       //  Calls: None                                               *
000410151020       //                                                            *
000411151020       //*************************************************************
000412151020
000413151020       begsr *inzsr;
000414151020       endsr;
000415151020
000416151020       //*************************************************************
000417151020       /EJECT
000418151020       //*************************************************************
000419151020       //                                                            *
000420151020       //   *pssr  - Program Error Processing Subroutine.            *
000421151020       //                                                            *
000422151020       //   Called By: Main Processing                               *
000423151020       //                                                            *
000424151020       //*************************************************************
000425151020
000426151020       begsr *pssr;
000427151020                   *inu7 = *on;
000428151020                   *inu8 = *on;
000429151020                   *Inlr = *on;
000430151020                   dump;
000431151020                   return;
000432151020       endsr;
000433151020      /end-free
000434151020
000435151020      *****************************************************************
000436151020      /EJECT
000437151020      *****************************************************************
000438151020      *                                                               *
000439151020      *  SrCommand - Execute CL Command                               *
000440151020      *                                                               *
000441151020      * Called by: Main Processing                                    *
000442151020      *                                                               *
000443151020      * Calls: QCMDEXC                                                *
000444151020      *                                                               *
000445151020      *****************************************************************
000446151020     C     SrCommand     BEGSR
000447151020     C                   EVAL      MessageID = *BLANKS
000448151020     C                   EVAL      CommandLen = 200
000449151020     C                   CALL  (E) 'QCMDEXC'
000450151020     C                   PARM                    CommandStr
000451151020     C                   PARM                    CommandLen       15 5
000452151020     C                   IF        %ERROR
000453151020     C                   EVAL      MessageID = PSExcpType+
000454151020     C                             PSExcpNo
000455151020     C                   ENDIF
000456151020     C                   ENDSR
