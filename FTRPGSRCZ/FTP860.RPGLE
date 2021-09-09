     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0008 - Check account on PCAT                              *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. EEE058 (*Amend)    Date 05Jun2003             *
      *  Prev Amend No. EEE058             Date 11Feb2003             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *           Add field DSMSEQ to key list KIndts2a               *
      *  EEE058 - For our manual and our month then no msgs           *
      *  EEE058 - Incoming STP idenifier is Elixir customer           *
      *                                                               *
      *****************************************************************
     F/EJECT
     FMEINCRL1  IF   E           K DISK
      *
      *  Message header for sender of message
      *
     FMEINMPL1  IF   E           K DISK
      *
      *  Message part information
      *
     FMEINDTS2  IF   E           K DISK
      *
      *  Message details in message/part/tag order
      *
     FFTBCORV0  IF   E           K DISK
      *
      *  Details of Bank Correspondent relationships
      *
     FFTLCORV0  IF   E           K DISK
      *
      *  Details of Loro Correspondent relationships
      *
     F/EJECT
      *****************************************************************
      *
      *  Copyright table
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      *  Copyright
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * SDBANKPD - Bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * SDCURRPD - Currency details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long data structure
      *
     D OutPay        E DS                  EXTNAME(OTPAYDD)  PREFIX(O_)
     D InPay         E DS                  EXTNAME(INPAYDD)  PREFIX(I_)
      * Payment Details
      *
     D Accounts      E DS                  EXTNAME(ACCNTAB)  PREFIX(E_)
      * Extension details
      *
     D Ftpext        E DS                  EXTNAME(FTPEXTP0)
      * Extension details
      *
      *
     D ##Country       S              2
     D DIGITS          C                   CONST('0123456789')
      *

      ** Data structure for information on OUR processing
     D O2Parm          DS           256
     D  O2Msgr                             LIKE(O_OPMSGR)
     D  O2Kprt                             LIKE(O_OPKPRT)
     D  O2Acod                             LIKE(E_ACOD)
     D  O2Gpcd                             LIKE(PXGPCD)
     D  O2Coma                       13S 0
     D  O2Penf                             LIKE(PXPENF)
     D  O2M900                             LIKE(BDM900)
     D  O2M191                             LIKE(BDM191)
     D/EJECT
      *****************************************************************

     I@INDTS2       01
     I@IN35S2       02
     I/EJECT
      *****************************************************************

      * Defintion of incoming data
      *
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *
     C     *Entry        Plist
     C                   Parm                    RetFtp860         7
     C                   Parm                    O2Parm
      *
      *  Only do processing is linked to message
      *
     C                   If        O2MSGR <> 0
     C                   Exsr      GetHeader
     C                   Endif
      *
      *  Exit program
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      * Get Message Header
      *****************************************************************
     C     GetHeader     BEGSR
      *
      * Get message headre
      *
     C     KIncrl1       KLIST
     C                   Kfld                    CRMSGR
      *
     C                   Eval      CRMSGR = O2MSGR
      *
     C     KIncrl1       Chain     @INCRL1
      * If found get message charge details
     C                   If        %Found
     C                   Exsr      GetCharge
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get Message Detail for charge
      *****************************************************************
     C     GetCharge     BEGSR
      *
      * Get message details
      *
     C     KIndts2a      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
     C                   Kfld                    DSMSEQ                                     AR856737
     C                   Kfld                    DSSEQN
      *
     C     KIndts2b      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
      *
     C                   Eval      DSMSGR = O2MSGR
     C                   Eval      DSPART = O2KPRT
     C                   Eval      DSMTG  = ':71A:'
     C                   Eval      DSSEQN = 0
     C                   Eval      DSMSEQ = *Blanks                                         AR856737
      *
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Reade     Meindts2
      * If found check for OUR
     C                   If        %Found
     C                   Select
     C                   When      (*in01 = *ON and DTMFLD = 'OUR') or
     C                             (*in02 = *ON and DSMF35 = 'OUR')
      *
      * Now check for 71G
     C                   Eval      DSMTG  = ':71G:'
     C                   Eval      DSSEQN = 0
     C                   Movel     *OFF          *In01
     C                   Movel     *OFF          *In02
      *
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Reade     Meindts2
      * If not found continue
     C                   If        *in01 = *off and *in02 = *off
     C                   Exsr      GetBankCorr
     C                   Else
      * Set no calculated charges as 71G exists
     C                   Eval      O2GPCD = '8002'
     C                   Eval      O2M900 = 'N'
     C                   Eval      O2M191 = 'N'
      * Now get amount from 71G
     C                   Select
     C                   When      *in01 = *on
     C     3             Subst     DTMFLD:1      ##Currency        3
     C     32            Subst     DTMFLD:4      ##Number         32
     C                   When      *in02 = *on
     C     3             Subst     DSMF35:1      ##Currency        3
     C     32            Subst     DSMF35:4      ##Number
     C                   Endsl
      * Translate ,
     C     ',':'.'       Xlate     ##Number      ##Number
      * Get currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY'        P@OPTN            7
     C                   PARM      ##Currency    P@CCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * If found format amount
     C                   If        P@RTCD = *blanks
      *
     C                   MOVEL     ##Number      ZFIELD
     C                   Eval      ZADec = A6NBDP
     C                   Eval      ZADig = 13 - A6NBDP
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM                    ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM      *BLANKS       ZAFLD            16            O:Check Field
     C
     C                   If        ZRTN = *blanks
     C                   MOVE      ZAFLD         O2Coma
     C                   Endif
     C
     C                   Endif
      *
     C                   Endif
     C                   Endsl
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get Bank Correspondent relationship
      *****************************************************************
     C     GetBankCorr   BEGSR
      *
      * Get bank correspondent details
      *
     C     KBcorv0       KLIST
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
      *
     C                   Eval      BDBICC = %subst(CRSNDR:1:8)
     C                   Eval      BDBICB = %subst(CRSNDR:9:3)
      *
     C                   If        BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
      *
     C     KBcorv0       Chain     @Bcorv0
      * if not found try with ???
     C                   If        Not %Found
     C                   Eval      BDBICB = '???'
      *
     C     KBcorv0       Chain     @Bcorv0
     C                   Endif
      *
      * Determine action depending on data
     C                   Select
      * if our manual then make sure last screen has no charge
     C                   When      %Found and  BDOMAN = 'Y'
     C                             and BDOMTH <> 'Y'                                          EEE058
     C                   Eval      O2GPCD = '8002'
      * if our monthly then make sure last screen has no charge
     C                   When      %Found and BDOMTH = 'Y'
     C                   Eval      O2GPCD = '8002'
     C                   Eval      O2M900 = 'N'
     C                   Eval      O2M191 = 'N'
      * otherwise check if this is a Loro customers
     C                   Other
     C                   Exsr      getLoroCorr
     C                   Endsl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get Loro Correspondent relationship
      *****************************************************************
     C     GetLoroCorr   BEGSR
      *
      * Get message part details
      *
     C     KInmpl1       KLIST
     C                   Kfld                    MPMSGR
     C                   Kfld                    MPKPRT
      *
     C                   Eval      MPMSGR = O2MSGR
     C                   Eval      MPKPRT = O2KPRT
      *
     C     KInmpl1       Chain     @INMPL1
      * If found get message charge details
     C                   If        %Found
     C                   Eval      BDLCCY = MPCYCD
     C                   Endif
      *
      * Check for 53 or 54
      *
     C     KIndts2c      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
      *
     C                   Eval      DSMTG  = ':53A:'
     C                   Movel     *OFF          *In01
     C                   Movel     *OFF          *In02
     C                   Movel     *blanks       ##NoCover         1
      *
     C     KIndts2b      Setll     Meindts2
     C     KIndts2c      Reade     Meindts2
      * If not found continue
     C                   Select
     C                   When      *in01 = *on
     C                   Movel     DTMTG         ##003a            3
      *
     C                   If        ##003a = ':53' and DTMTG <> ':53B:'
     C                             or ##003a = ':54'
     C                   Movel     'Y'           ##NoCover
     C                   Endif
      *
     C                   When      *in01 = *on
     C                   Movel     DSMTG         ##003a            3
      *
     C                   If        ##003a = ':53' and DSMTG <> ':53B:'
     C                             or ##003a = ':54'
     C                   Movel     'Y'           ##NoCover
     C                   Endif
      *
     C                   Endsl
      *
      * Get bank correspondent details
      *
     C     Klcorv0       KLIST
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
     C                   Kfld                    BDLCCY
      *
     C                   Eval      BDBICC = %subst(CRSNDR:1:8)
     C                   Eval      BDBICB = %subst(CRSNDR:9:3)
      *
     C                   If        BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
      *
     C     KLcorv0       Chain     @Lcorv0
      * if not found try with ???
     C                   If        Not %Found
     C                   Eval      BDBICB = '???'
      *
     C     KLcorv0       Chain     @Lcorv0
     C                   Endif
      *
      * Get country code of Sender
     C                   Eval      ##Country = %subst(CRSNDR:5:2)
     C                   Exsr      RetGroupCode
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Return correct group code
      *****************************************************************
     C     RetGroupCode  BEGSR
      *
      * Return group code
      *
      *
      * Determine action depending on data
     C                   Select
      * if found then Loro else it is a nostro
     C                   When      %Found and ##NoCover <> 'Y'
     C                   Eval      O2M900 = 'N'
     C                   Eval      O2M191 = 'N'
      * Determine action depending on data
     C                   Select
     C                   When      BDM191 = 'Y'
     C                   Eval      O2M191 = 'Y'
      * Mt191 and charge depends on location of sender
     C                   If        ##Country = 'PL'
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7003'
     C                   ELse
     C                   Eval      O2GPCD = '7007'
     C                   Endif
     C                   Else
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7001'
     C                   ELse
     C                   Eval      O2GPCD = '7005'
     C                   Endif
     C                   Endif
      *
     C                   When      BDM900 = 'Y'
     C                   Eval      O2M900 = 'Y'
      * Mt900 and charge depends on location of sender
     C                   If        ##Country = 'PL'
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7004'
     C                   ELse
     C                   Eval      O2GPCD = '7008'
     C                   Endif
     C                   Else
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7002'
     C                   ELse
     C                   Eval      O2GPCD = '7006'
     C                   Endif
     C                   Endif
      *
     C                   Other
     C                   Endsl
      *
     C                   Other
      * Mt191 and charge depends on location of sender
     C                   Eval      O2M900 = 'N'
     C                   Eval      O2M191 = 'Y'
     C                   If        ##Country = 'PL'
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7003'
     C                   ELse
     C                   Eval      O2GPCD = '7007'
     C                   Endif
     C                   Else
     C                   If        O2Penf <> 'Y'
     C                   Eval      O2GPCD = '7001'
     C                   ELse
     C                   Eval      O2GPCD = '7005'
     C                   Endif
     C                   Endif
      *
     C                   Endsl
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
