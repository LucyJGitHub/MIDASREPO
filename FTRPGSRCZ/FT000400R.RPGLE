     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Unlock Payment Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer Module                                 *
      *                                                               *
      *  FT000400R - FT Unlock Payment Screen                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD024626 *CREATE   Date 15Oct15               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD024626 - No access to Payment after expired or closed      *
      *             session. New screen created to unlock payment.    *
      *             Applied for MD-36065.                             *
      *                                                               *
      *****************************************************************
     FFT000400DFCF   E             WORKSTN
     FOTPAY     IF   E           K DISK    PREFIX(OT_)
     FINPAY     IF   E           K DISK    PREFIX(IN_)

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Main            pr                  extpgm('FT000400R')
     D  modeOperation                10a   const options(*nopass)
     D Main            pi
     D  modeOperation                10a   const options(*nopass)

     D  UnlockRoutine  pr                  extpgm('FTC000400')
     D    pReturnCode                 7a
     D    pDataArea                  10a
     D    pUser                      10a
     D    pMode                      10a

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D SDSTAT        e ds                  extname(SDSTAT) dtaara(SDSTAT)
     D RUNDAT        e ds                  extname(RUNDAT) dtaara(RUNDAT)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D  modeOP         s             10a
     D  paymentRef     s             10a
     D  dataAreaName   s             10a   inz(*blanks)
     D  paymentType    s              2a   inz(*blanks)
     D  isExit         s               n   inz(*off)
     D  isFound        s               n   inz(*off)
     D  isValidPREF    s               n   inz(*off)
     D  isValidUSER    s               n   inz(*off)
     D  MessageID      s              7a   inz(*blanks)
     D  CommandStr     s            200a   inz(*blanks)

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      /free

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

                   user = psuser;
                   job = psjobname;
                   in RunDat;
                   date = AGMRDT;

                   dow not (isExit);

                      if modeOperation = '*SAME';
                         *In60 = *On;
                         suser = psuser;
                      endif;
                      exfmt FT000400D0;

                      select;
                         when *In03 = *On;
                            Leave;
                         when *In10 = *On;
                            exsr UnlockPayment;
                         other;
                            exsr validatePaymentReference;
                            exsr validateUserName;
                            if isValidPREF and isValidUSER;
                               *In64 = *On;
                            else;
                               *In64 = *Off;
                            endif;
                      endsl;
                   enddo;

                   *Inlr = *On;
                   return;

       //*************************************************************
       //                                                            *
       // validatePaymentReference                                   *
       // ========================                                   *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: *none                                               *
       //                                                            *
       //*************************************************************

       begsr validatePaymentReference;

       //Check if payment reference is entered
                   *In11 = *Off;
                   isValidPREF = *On;
                   if spref = *Blanks;
                      ermsg = 'Payment reference must be entered';
                      exsr setupPError;
                   endif;

                   paymentType = %subst(spref:12:2);

       //Check if payment reference exist
                   select;
                      when paymentType = 'OP';
                           paymentRef = 'O' + %subst(spref:3:9);
                           chain (spref) otpay;
                           eval isFound = %found;
                           if not(isFound);
                              ermsg = 'Payment reference does not exist in ' +
                                      'outgoing payments file';
                              exsr setupPError;
                           endif;

                      when paymentType = 'IN';
                           paymentRef = 'I' + %subst(spref:3:9);
                           chain (spref) inpay;
                           eval isFound = %found;
                           if not(isFound);
                              ermsg = 'Payment reference does not exist in ' +
                                      'incoming payments file';
                              exsr setupPError;
                           endif;
                      other;
                         ermsg = 'Invalid payment details is entered';
                         exsr setupPError;
                   endsl;

                   if isValidPREF;
                      erMsg = *blanks;
                   endif;

       endsr;
       //*************************************************************
       //                                                            *
       // unlockPayment                                              *
       // =============                                              *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: *none                                               *
       //                                                            *
       //*************************************************************

       begsr unlockPayment;

       // Check if data area exist
             CommandStr =  'CHKOBJ OBJ(' +
                            %Trim(paymentRef) + ') ' +
                            'OBJTYPE(*DTAARA) AUT(*ALL)';
             exsr SrCommand;
             if MessageID = 'CPF9801';
                erMsg = %Trim(spref) + ' is not locked';
                exsr setupPError;
                LeaveSR;
             endif;
             modeOp = modeOperation;

             callp UnlockRoutine(
                                  returnCode:
                                  paymentRef:
                                  suser:
                                  modeOp
                                );
             if returnCode <> *blanks and returnCode <> '*USER'
                and returnCode <> '*NONE' and returnCode <> '*NEND';
                dBkey = *blanks;
                dBfile = *Blanks;
                dBase = 002;
                dBpgm  = 'FTC000400';
                exsr *pssr;
             elseif returnCode = '*USER';
                erMsg = %Trim(suser) +
                'is not allowed to end job of another user';
                *In50 = *On;
                *In11 = *On;
                LeaveSR;
             elseif returnCode = '*NONE';
                erMsg = %Trim(suser) +
                        ' is not associated with the payment reference '
                        + spref;
                *In50 = *On;
                *In11 = *On;
                LeaveSR;
             elseif returnCode = '*NEND';
                erMsg = 'Job cannot be ended at this time';
                *In50 = *On;
                *In11 = *On;
                LeaveSR;
             else;
                erMsg = %Trim(spref) + ' is now unlocked by ' + %Trim(suser);
                *In50 = *On;
                spref = *blanks;
                suser = *blanks;
             endif;

       endsr;

       //*************************************************************
       //                                                            *
       // validateUserName                                           *
       // ================                                           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: *none                                               *
       //                                                            *
       //*************************************************************

       begsr validateUserName;

                   if not(isValidPREF);
                      LeaveSr;
                   endif;

                   *In12 = *Off;
                   isValidUSER = *On;
                   if suser = *Blanks;
                      ermsg = 'User name must be entered';
                      *In50 = *On;
                      *In12 = *On;
                      isValidUSER = *Off;
                      leaveSr;
                   endif;

                   if isValidUSER;
                      erMsg = *blanks;
                   endif;


       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // setupPError                                                *
       //                                                            *
       // Called by: validatePaymentReference                        *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr setupPError;
                   *In50 = *On;
                   *In11 = *On;
                   isValidPREF = *Off;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // inzsr - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr *inzsr;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *pssr  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr *pssr;
                   *inu7 = *on;
                   *inu8 = *on;
                   *Inlr = *on;
                   dump;
                   return;
       endsr;
      /end-free

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
     C                   EVAL      MessageID = *BLANKS
     C                   EVAL      CommandLen = 200
     C                   CALL  (E) 'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen       15 5
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType+
     C                             PSExcpNo
     C                   ENDIF
     C                   ENDSR
