      *****************************************************************
      *                                                               *
      *  Midas - FT Module                                            *
      *                                                               *
      *  JMI111_009 - GLBITHVAL                                       *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2018             *
      *                                                               *
      *  Last Amend No. JMI111 *CREATE     Date 18May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *                                                               *
      *****************************************************************
      *                                                                                       JMI111
      ** Access the switchable features file, to see if the feature                           JMI111
      ** JMI111 is on.                                                                        JMI111
     C                   MOVE      'N'           JMI111                                       JMI111
      *                                                                                       JMI111
     C                   CALL      'AOSARDR0'                                                 JMI111
     C                   PARM      *BLANKS       @RTCD9            7                          JMI111
     C                   PARM      '*VERIFY'     @OPTN             7                          JMI111
     C                   PARM      'JMI111'      @SARD             6                          JMI111
     C     SCSARD        PARM      SCSARD        DSFDY                                        JMI111
      *                                                                                       JMI111
     C                   IF        @RTCD9 = *BLANKS                                           JMI111
     C                   MOVE      'Y'           JMI111            1                          JMI111
     C                   ELSE                                                                 JMI111
     C                   MOVE      'N'           JMI111            1                          JMI111
     C                   ENDIF                                                                JMI111
      *                                                                                       JMI111
     C                   IF        JMI111 = 'Y'                                               JMI111
      *                                                                                       JMI111
     C                   EVAL      UPSEQ = '00001'                                            JMI111
     C                   EVAL      D#BTNB = DDBTNB                                            JMI111
     C                   EVAL      D#MSG  = *BLANKS                                           JMI111
      *                                                                                       JMI111
     C                   CALL      'XXBITHVAL'                                                JMI111
     C                   PARM      'I'           @ACTN             1                          JMI111
     C                   PARM                    DATA2                                        JMI111
     C                   PARM                    DATAI                                        JMI111
     C                   PARM                    DATAF1                                       JMI111
     C                   PARM                    DATAF2                                       JMI111
     C                   PARM                    DATAF3                                       JMI111
     C                   PARM                    DATAF4                                       JMI111
     C                   PARM      *BLANKS       @RETRN            7                          JMI111
                                                                                              JMI111
     C                   MOVE      *BLANKS       W1FRNT            5                          JMI111
     C                   IF        JAVAUSER = 'Y' AND                                         JMI111
     C                             DDBTNB <> *BLANKS                                          JMI111
     C                   OPEN      GLJENHL0                                                   JMI111
     C     DDBTNB        CHAIN     @BRREAG                                                    JMI111
     C                   IF        %FOUND(GLJENHL0)                                           JMI111
     C                   EVAL      W1FRNT = %SUBST(I_BRFRNT:1:5)                              JMI111
     C                   ENDIF                                                                JMI111
     C                   CLOSE     GLJENHL0                                                   JMI111
     C                   ENDIF                                                                JMI111
     C*                                                                                       JMI111
     C                   IF        W1FRNT <> 'OPICS'    AND                                   JMI111
     C                             JMI111 = 'Y'                                               JMI111
     C*                                                                                       JMI111
     C     D#MSG         IFEQ      'GLX0511'                                                  JMI111
     C                   EXSR      SRRESET                                                    JMI111
     C*********          EVAL      FLDNAMXAR(1) = 'DDBTNB'                             JMI111 JMI111
     C*********          MOVEL     'GLX0511'     MsgIdXAR(1)                           JMI111 JMI111
     C                   ADD       1             Idx                                          JMI111
     C                   MOVEL     'DDBTNB'      FldNamXAr(Idx)                               JMI111
     C                   MOVEL     'GLX0511'     MsgIdXAr(Idx)                                JMI111
     C                   EVAL      BLen = %Len(%Trim(D#MSG))                                  JMI111
     C                   EVAL      MsgDtaTmp = LenStr +%TRIM(D#MSG)                           JMI111
     C                   EVAL      D#MSGDTAXAR1 = OPLRBN                                      JMI111
     C                   EVAL      D#MSGDTAXAR2 = ' - '                                       JMI111
     C                   EVAL      D#MSGDTAXAR3 = OPURBN                                      JMI111
     C                   EVAL      MSGDTATMP = #DMSGDTAXAR                                    JMI111
     C                   EVAL      BLen = %Len(%Trim(MSGDTATMP))                              JMI111
     C*********          EVAL      MsgDtaXAR(1) = LenStr +%TRIM(MSGDTATMP)             JMI111 JMI111
     C                   EVAL      MsgDtaXAR(Idx) = LenStr +%TRIM(MSGDTATMP)                  JMI111
     C                   EXSR      SRUPDERR                                                   JMI111
     C                   ENDIF                                                                JMI111
                                                                                              JMI111
     C                   ENDIF                                                                JMI111
     C*                                                                                       JMI111
     C     @RETRN        IFEQ      '*ERROR'                                                   JMI111
     C                   EVAL      DBFILE =  'XXBITHVAL'                                      JMI111
     C                   EXSR      *PSSR                                                      JMI111
     C                   ENDIF                                                                JMI111
      *                                                                                       JMI111
     C                   ENDIF                                                                JMI111
     C*                                                                                       JMI111
      *                                                                                       JMI111
      ** End of /COPY JMI111_009                                       *                      JMI111
      *                                                                                       JMI111
