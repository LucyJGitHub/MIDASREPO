     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
/*EXI *  TEXT('Midas FT Get Charge Details')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  FTP1100 - Get Charge Details                                 *
      *                                                               *
      *  Function:  Extracts charges data from one message and        *
      *  returns a data structure.                                    *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 STP994             Date 09Apr2005             *
      *                 ESL038 (*Amend)    Date 29Nov2004             *
      *                 EEE058             Date 11Feb2003             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *           Add field DSMSEQ to key list KIndts2a               *
      *  STP994 - Clear ##Value even when the tag was not found for   *
      *           given transaction.                                  *
      *  ESL038 - ING STP enhancements                                *
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
     DDSFDY          E DS                  Extname(DSFDY)
      * Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long data structure
      *
     D OutPay        E DS                  EXTNAME(OTPAYDD)  PREFIX(O_)
      * Payment Details
      *
     D Accounts      E DS                  EXTNAME(ACCNTAB)  PREFIX(E_)
      * Extension details
      *
     D Ftpext        E DS                  EXTNAME(FTPEXTP0)
      * Extension details
      *
      * Container array for charges
     DAry              S                   Dim(17) Like(O2SubDs)
      *
     D##Code           S              5A
     Dctr              S              2S 0
     D##ChrgNumber     S                   Like(##Nbr   )
     D@@Currency       S                   Like(##Currency)
     D@@In             S             14A
     D@@Out            S                   Like(O2Amt)
     D@@Outa           S                   Like(W3OUT21   )
     D##Holder         S             30P 0
     D##Value          S              8A
      *
     D ##Country       S              2
     D DIGITS          C                   CONST('0123456789')
      *
 
     D D#DTA           DS           256
      *
      *  Calling parameter data structure for AOCCYCV0
      *
      *                                       From Currency & amount
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
      *                                       To Currency & amount
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
      *                                       Rate and multi/div ind.
     D  D#MDIN                23     23
     D  D#RATE                24     36P 8
      *                            Output     Rate and multi/div ind.
      *                                       If no in rate
     D  O#MDIN                37     37
     D  O#RATE                38     50P 8
      *
      ** Parameter data structures.
     D O1Parm          DS           256
     D  O1Msgr                             LIKE(O_OPMSGR)
     D  O1Kprt                             LIKE(O_OPKPRT)
     D  O1Lhcy                             Like(O_Smcy)
      *
      * Change these (below) to fit in with current proj.
      *
      * Return this DS as a parameter.
     DO2Parm           DS          1400
     D O2ChgDS1                     100
     D O2ChgDS2                     100
     D O2ChgDS3                     100
     D O2ChgDS4                     100
     D O2ChgDS5                     100
     D O2ChgDS6                     100
     D O2ChgDS7                     100
     D O2ChgDS8                     100
     D O2ChgDS9                     100
     D O2ChgDS10                    100
     D O2ChgDS11                    100
     D O2ChgDS12                    100
     D O2ChgDS13                    100
     D O2ChgDS14                    100
 
      * This data structure is used to populate the O2Parm data structure
     D O2SubDS         DS           100
     D O2Tag                          5A
     D  O2Code                        5A
     D  O2Ccy                              LIKE(O_SMCY)
     D  O2Msgdta                     15A
     D  O2Amt                        13S 0
     D  O2Amta                       14A
     D  O2ChrgEqv                    13S 0
     D  O2ChrgEqva                   14A
 
     DO3Parm           DS            30
     D O3Cnbkr                        8A
     D O3Bookc                             Like(O_BOKC)
     D O3Subtp                             Like(O_PYST)
 
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
     C                   Parm                    RetFtp1100        7
     C                   Parm                    O1Parm
     C                   Parm                    O2Parm
     C                   Parm                    O3Parm
 
      * Get bank details to determine base currency
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Only do processing is linked to message
      *
     C                   If        O1MSGR <> 0
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
      * Get message header
      *
     C     KIncrl1       KLIST
     C                   Kfld                    CRMSGR
      *
     C                   Eval      CRMSGR = O1MSGR
      *
     C     KIncrl1       Chain     @INCRL1
      * If found get message charge details
     C                   If        %Found
     C                   Exsr      GetCharge
     C                   Exsr      SrOtherTags
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
     C                   Eval      DSMSGR = O1MSGR
     C                   Eval      DSPART = O1KPRT
 
     C                   For       ctr = 1 to 14
     C                   Select
      * Tag TRFCM (transfer commission)
     C                   When      ctr = 1
      * Load key to Meindt* logical file
     C                   Eval      DSMTG  = 'TRFCM'
      * Tag MISC    (Miscellaneous Charge)
     C                   When      ctr = 2
     C                   Eval      DSMTG  = 'MISC'
      * Tag MISC1   (Miscellaneous Charge 1)
     C                   When      ctr = 3
     C                   Eval      DSMTG  = 'MISC1'
      * Tag MISC2   (Miscellaneous Charge 2)
     C                   When      ctr = 4
     C                   Eval      DSMTG  = 'MISC2'
      * Tag MISC3   (Miscellaneous Charge 3)
     C                   When      ctr = 5
     C                   Eval      DSMTG  = 'MISC3'
      * Tag MISC4   (Miscellaneous Charge 4)
     C                   When      ctr = 6
     C                   Eval      DSMTG  = 'MISC4'
      * Tag MISC5   (Miscellaneous Charge 5)
     C                   When      ctr = 7
     C                   Eval      DSMTG  = 'MISC5'
      * Tag TELPH   (Telephone Charge)
     C                   When      ctr = 8
     C                   Eval      DSMTG  = 'TELPH'
      * Tag ADVCH   (Advice Charge)
     C                   When      ctr = 9
     C                   Eval      DSMTG  = 'ADVCH'
      * Tag TELXC   (Telex Charge)
     C                   When      ctr = 10
     C                   Eval      DSMTG  = 'TELXC'
      * Tag SWFTC   (SWIFT Charge)
     C                   When      ctr = 11
     C                   Eval      DSMTG  = 'SWFTC'
      * Tag SWFTP   (SWIFT Priority Charge)
     C                   When      ctr = 12
     C                   Eval      DSMTG  = 'SWFTP'
      * Tag CSTAB   (Costs Abroad)
     C                   When      ctr = 13
     C                   Eval      DSMTG  = 'CSTAB'
      * Tag CHEQC   (Cheque Charge)
     C                   When      ctr = 14
     C                   Eval      DSMTG  = 'CHEQC'
     C                   Endsl
     C                   Eval      O2Tag  = DSMTG
     C                   Exsr      Unpack
     C                   Eval      Ary(ctr) = O2SubDs
     C                   Clear                   O2SubDS
 
     C                   Endfor
      *
     C                   Movea     Ary           O2Parm
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CalcBaseEquiv - Calculate Chrg Currency Equivalent Amount    *
      *****************************************************************
     C     CalcBaseEquiv Begsr
      *
      *
      * Convert amount to chrg currency
      *
     C                   CLEAR                   D#DTA
     C                   Move      @@Out         D#FAMT
     C                   Eval      D#FCCY = ##Currency
     C                   Eval      D#TCCY = BJCYCD
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
 
     C                   If        O#RTN = *blanks
     C                   Eval      O2ChrgEqv    = D#TAMT
     C                   EndIf
      * Convert to screen format
     C                   Move      D#Tamt        @@Out
     C                   Exsr      SrCnvToScrF
     C                   Eval      O2ChrgEqva = %subst(@@Outa:07:14)
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrUnpack - unpack data from file record                       *
      *****************************************************************
     C     Unpack        Begsr
 
     C                   Move      *off          *in01
     C                   Move      *off          *in02
     C                   Eval      DSMSEQ = *Blanks                                         AR856737
      * See if the tag exists
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Chain     Meindts2
 
     C                   If        %Found
      * Test for '/CODE/nnnnn' format
     C                   If        %Subst(DTMFLD:1:6) = '/CODE/'
      *
     C                   Select
     C                   When      *in01 = *on
     C                   Eval      ##Code = %Subst(DTMFLD:7:11)
     C                   When      *in02 = *on
     C                   Eval      ##Code = %Subst(DSMF35:7:11)
     C                   Endsl
     C                   Eval      O2Code = ##Code
      * Otherwise must be ccy:amount format
     C                   Else
      * Now get amount
     C                   Select
     C                   When      *in01 = *on
     C     3             Subst     DTMFLD:1      ##Currency        3
     C     32            Subst     DTMFLD:4      ##Nbr            32
     C                   Eval      O2Msgdta = DTMFLD
     C                   When      *in02 = *on
     C     3             Subst     DSMF35:1      ##Currency        3
     C     32            Subst     DSMF35:4      ##Nbr
     C                   Eval      O2Msgdta = DSMF35
     C                   Endsl
      * Replace comma with decimal point
     C                   Eval      ##Nbr = (
     C                             %Replace('.':##Nbr:%Scan(',':##Nbr):1))
      *
      * Format amount in transaction currency
      *
     C                   Eval      @@Currency = ##Currency
     C                   Movel     ##Nbr         @@In
     C                   Exsr      SrFormat
     C                   Eval      O2Amt = @@Out
     C                   Exsr      SrCnvToScrF
     C                   Eval      O2Amta = %subst(@@Outa:07:14)
     C                   Eval      O2Ccy = ##Currency
      *
      * Do Base Currency Equivalent calculation
      *
     C                   EXSR      CalcBaseEquiv
 
     C                   Endif
     C                   Endif
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SrFormat - format amounts                                     *
      *****************************************************************
     C     SrFormat      Begsr
      *
      * Get currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY'        P@OPTN            7
     C                   PARM      @@Currency    P@CCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * If found format amount
     C                   If        P@RTCD = *blanks
      *
     C                   Clear                   ZFIELD
     C                   Movel     @@In          ZFIELD
     C                   Eval      ZADec = A6NBDP
     C                   Eval      ZADig = 11 - A6NBDP
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM                    ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM      *BLANKS       ZAFLD            16            O:Check Field
     C
     C                   If        ZRTN = *blanks
     C                   MOVE      ZAFLD         @@Out
     C                   Endif
 
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrCnvToScrF - Convert to screen format                        *
      *****************************************************************
     C     SrCnvToScrF   Begsr
      * NB Using A6NBDP from AOCURRR0 call in SrFormat.
     C                   Move      @@Out         W3fld15
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C                   Move      W3out21       @@Outa
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrOtherTags - Get non-charge tags                             *
      *****************************************************************
     C     SrOtherTags   Begsr
     C                   Eval      DSMSGR = O1MSGR
     C                   Eval      DSPART = O1KPRT
     C                   For       ctr = 1 to 3
     C                   Select
     C                   When      ctr = 1
      * Central Bank Reference
     C                   Eval      DSMTG  = 'CBNKR'
     C                   Exsr      SrExtTagDta
     C                   Eval      O3Cnbkr = %subst(##Value:1:8)
     C                   When      ctr = 2
      * Book code
     C                   Eval      DSMTG  = 'BOOKC'
     C                   Exsr      SrExtTagDta
     C                   Eval      O3Bookc = %subst(##Value:1:2)
     C                   When      ctr = 3
      * Payment sub-type
     C                   Eval      DSMTG  = 'SUBTP'
     C                   Exsr      SrExtTagDta
     C                   Eval      O3Subtp = %subst(##Value:1:2)
     C                   Endsl
     C                   Endfor
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrExtTagDta - Get non-charge tag data                         *
      *****************************************************************
     C     SrExtTagDta   Begsr
 
     C                   Move      *off          *in01
     C                   Move      *off          *in02
     C                   Clear                   ##Value                                      STP994
     C                   Eval      DSMSEQ = *Blanks                                         AR856737
      * See if the tag exists
 
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Reade     Meindts2
 
     C                   If        %Found
     C*****              Clear                   ##Value                                      STP994
     C                   Select
     C                   When      *in01 = *on
     C                   Eval      ##Value = %Subst(DTMFLD:1:8)
     C                   When      *in02 = *on
     C                   Eval      ##Value = %Subst(DSMF35:1:8)
     C                   Endsl
     C                   Endif
 
     C                   Endsr
      *****************************************************************
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2004
