     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Credit Authorisation Cascade')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP1130 - Credit Authorisation Cascade                       *
      *                                                               *
      *  Function:  Authorise payment after first level authorisation *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 CHG004             Date 24Jul06               *
      *                 PNL004             Date 13Jul06               *
      *                 PNL012             Date 16Sep05               *
      *                 235224             Date 02Aug05               *
      *                 233571             Date 29Jun05               *
      *                 ESL038             Date 09Dec2004             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  CHG004 - PNL004 CR4. FT file format change.                  *
      *  PNL004 - Add missing processing of PNL004 to PNL012.         *
      *  PNL012 - Account Payments Authorisation Processing           *
      *           Also added 233571, 235224                           *
      *  235224 - Exit the loop if key changes for FTCRCKV2.          *
      *  233571 - Update the file under the correct conditions.       *
      *  ESL038 - ING STP enhancements                                *
      *                                                               *
      *****************************************************************
     F/EJECT
     FMEINFTL0  UF   E           K DISK    Commit                                             MARCIN
     F*FTCRCKV0  IF   E           K DISK                                                      PNL012
     FFTCRCKV0  UF   E           K DISK    Commit                                             PNL012
      *  Midas FT Credit Check File by posting reference
      *
     FFTCRCKV2  UF   E           K DISK    Commit
      *  Midas FT Credit Check File by DR account reference
      *
     FINPAY     UF   E           K DISK    Commit  USROPN
      *  Incoming Payments
      *
     F*****INPAYXL0  IF   E           K DISK                                                  PNL013
     FINPAYXL0  IF   E           K DISK    USROPN                                             PNL013
      *  Incoming Payments extension file
      *
     FOTPAY     UF   E           K DISK    Commit  USROPN
      *  Outgoing Payments
      *
     FOTPAYXL0  IF   E           K DISK    USROPN                                             MAR013
      *  Outgoing Payments - Extension File                                                   MAR013
      *                                                                                       MAR013
     F/EJECT
      *****************************************************************
      *
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
      *
     D*COPY MECPYSRC,SRERRD_ILE      *MBR INCLUDED BELOW*
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SRERRD_ILE - Midas Error Processing - 'D' Specs              *
      *                                                               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CSW200  *CREATE    Date 03AUG00               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW200 - Swift 2000 Changes.                                 *
      *                                                               *
      *****************************************************************
      *
     D @STK            S             10    DIM(20)
      *
      *  Subroutine stack
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Program data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *  Local data area for database error details
      *  *LOCK IN LDA immediately before and OUT LDA immediately
      *  after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  PNL004
      *External data structure for Bank Details                                               PNL004
      *                                                                                       PNL004
     D ERDTA         E DS                  EXTNAME(MEERDTA)
      *
      *  Send message data structure
      *
      *                                       1  10 ERPGM
      *                                      11  20 ERFILE
      *                                      21  50 ERKEY
      *                                      51  550ERERNB
      *                                      56 135 ERNARR
      *                                     136 145 ERSTK
      *                                     146 175 ERPREF
      *
      *                                                                                       PNL004
     D PAYMSG        E DS                  EXTNAME(FTPAYDPP)                                  PNL004
      ***  Message layout for Funds Transfer                                                  PNL004
     D  PPCNUM       E                     EXTFLD(PCNUM)                                      PNL004
      *                                                                                       PNL004
     D PAYSID          DS                                                                     PNL004
     D  @TYPEP                 1      1                                                       PNL004
     D  @ACCTP                 2     19                                                       PNL004
     D  @CNU1                  2      7  0                                                    PNL004
     D  @CCY1                  8     10                                                       PNL004
     D  @ACD1                 11     14  0                                                    PNL004
     D  @ACS1                 15     16  0                                                    PNL004
     D  @BRC1                 20     22                                                       PNL004
     D  @BRCAP                20     22                                                       PNL004
      *                                                                                       PNL004
     D SETSID          DS                                                                     PNL004
     D  @TYPES                 1      1                                                       PNL004
     D  @ACCTS                 2     19                                                       PNL004
     D  @CNU2                  2      7  0                                                    PNL004
     D  @CCY2                  8     10                                                       PNL004
     D  @ACD2                 11     14  0                                                    PNL004
     D  @ACS2                 15     16  0                                                    PNL004
     D  @BRC2                 20     22                                                       PNL004
     D  @BRCAS                20     22                                                       PNL004
      *                                                                                       PNL004
     D CHGSID          DS                                                                     PNL004
     D  @TYPEC                 1      1                                                       PNL004
     D  @ACCTC                 2     19                                                       PNL004
     D  @BRCAC                20     22                                                       PNL004
     D  @CCYC                 23     25                                                       PNL004
      *                                                                                       PNL004
     D P@ACCT          DS          1000                                                       PNL004
      *  DS for AOIBANR4 Return                                                               PNL004
     D  CNUM#1                 2      7  0                                                    PNL004
     D  CCY#1                  8     10                                                       PNL004
     D  ACOD#1                11     14  0                                                    PNL004
     D  ACSQ#1                15     16  0                                                    PNL004
     D  BRCA#1                23     25                                                       PNL004
      *                                                                                       PNL004
     D O#1000          DS          1000                                                       PNL004
      ***  Message for ZEXTRACT Program                                                       PNL004
     D M#DTA           DS           256
      *
      *  Message Data - Action field
      *
      *                          Field Text
     D  #MSGTX                 1     80
      *                          Data Text
     D  ##MSGD                81    256
      *****************************************************************
      * End of /COPY SRERRD_ILE                                       *
      *****************************************************************
      *
      *  Copysource for error processing
      *
      *
      *  Copyright
      *
     DSCSARD         E DS                  Extname(SCSARDPD)                                  PNL012
      * CARs Access Object                                                                    PNL012
      *                                                                                       PNL012
     DDSFDY          E DS                  Extname(DSFDY)
      * Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long data structure
      *
     D ACCINF        E DS                  ExtName(ACCNTAB)                                   EMRMK1
     D                                     Prefix(ACC)                                        EMRMK1
      **
     D                 DS
     D  ##PREF                 1     15
     D  ##PTYP                12     13
      *
      ** Input data for call to FTP780
     D P@IDTA          DS
      *   Party one
     D  PITP1                  1      1
     D  PIPRY1                 2     36
      *   Party two
     D  PITP2                 37     37
     D  PIPRY2                38     72
      *   Party three
     D  PITP3                 73     73
     D  PIPRY3                74    108
      *   Account currency, amount, date
     D  PICCY                109    111
     D  PIAMNT               112    126  0
     D  PIPDTE               127    131  0
      *   Payment Reference and type
     D  PIPREF               132    146
     D  PIPTYP               147    148
      *   Branch of partys
     D  PIBRC1               149    151
     D  PIBRC2               152    154
     D  PIBRC3               155    157
      *   Booking branch
     D  PIBRCB               158    160
      *   Settlement currency and amount, rate, Pay currency and amount
     D  PISMCY               171    173
     D  PISMAM               174    186  0
     D  PIRATE               187    199  9
     D  PIPCCY               200    202
     D  PIPYAM               203    215  0
      *
      ** Output data for call to FTP780
     D P@ODTA          DS
     D  POBRCA                 1      3
     D  POCNUM                 4      9
     D  POCCY                 10     12
     D  POACOD                13     16
     D  POACSQ                17     18
     D  POCLBL                19     33  0
     D  POODLN                34     48  0
     D  POAVBL                49     63  0
     D  PODRCK                64     64
      *
      * Define work fields
     D**##CRBrca                           Like(CRCBRC)                                       MAR012
     D**##CRCust                           Like(CRCCUS)                                       MAR012
     D**##CRCcy                            Like(CRCCCY)                                       MAR012
     D**##CRAcod                           Like(CRCACD)                                       MAR012
     D**##CRAcsq                           Like(CRCASQ)                                       MAR012
     D  ##ERROR                       7
     D  P@AUTH                        1
      *
     IOTPAYDDF
     I              RECI                        ORECI
     IINPAYDDF
     I              RECI                        IRECI
      *****************************************************************
      /EJECT
      *
      *  Set up copyright statement
     C                   MOVEA     CPY@          BIS@             80
      *
      * Defintion of incoming data
     C     *Entry        Plist
     C                   Parm                    P#Return          7
     C                   Parm                    P#Pref           15
     C                   Parm                    @FTMSGR           8 0                        MARCIN
     C                   Parm                    @FTKPRT           3 0                        MARCIN
      *
      ** Get Credit account for incoming payment
     C                   Exsr      Sr_GetCrAc
      *
      ** Update credit check file for all payments with same credit a/c
     C                   Exsr      Sr_UpdCrAc
      *
      *  Exit program
     C                   RETURN
      /EJECT
      *****************************************************************                       PNL012
      * *INZSR - Init                                                                         PNL012
      *****************************************************************                       PNL012
     C     *INZSR        Begsr                                                                PNL012
      *                                                                                       PNL004
     C                   CALL      'AOBANKR0'                                                 PNL004
     C                   PARM      '*DBERR '     @RTCD             7                          PNL004
     C                   PARM      '*FIRST '     @OPTN             7                          PNL004
     C     SDBANK        PARM      SDBANK        DSFDY                                        PNL004
      *                                                                                       PNL012
      ** Access AO/AOSARDR0 to check if PNL012 is switched on                                 PNL012
      *                                                                                       PNL012
     C                   CALL      'AOSARDR0'                                                 PNL012
     C                   PARM      *BLANKS       @RTCD             7                          PNL012
     C                   PARM      '*VERIFY'     @OPTN             7                          PNL012
     C                   PARM      'PNL012'      @SARD             6                          PNL012
     C     SCSARD        PARM      SCSARD        DSFDY                                        PNL012
      *                                                                                       PNL012
     C     @RTCD         IFEQ      *BLANKS                                                    PNL012
     C                   MOVE      'Y'           PNL012            1                          PNL012
     C                   ELSE                                                                 PNL012
     C                   MOVE      'N'           PNL012                                       PNL012
     C                   ENDIF                                                                PNL012
      *                                                                                       PNL004
      ** Determine if CAR PNL004 is installed                                                 PNL004
      *                                                                                       PNL004
     C                   MOVE      'N'           PNL004            1                          PNL004
      *                                                                                       PNL004
     C                   CALL      'AOSARDR0'                                                 PNL004
     C                   PARM      *BLANKS       P#Return                                     PNL004
     C                   PARM      '*VERIFY '    @OPTN                                        PNL004
     C                   PARM      'PNL004'      @SARD                                        PNL004
      *                                                                                       PNL004
     C     P#Return      IFEQ      *BLANKS                                                    PNL004
     C                   MOVE      'Y'           PNL004                                       PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVE      'N'           PNL004                                       PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
 
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'INPAYXL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      INPAYXL0
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *                                                                                       PNL012
      * Open file OTPAYXL0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV0 to share(*NO)
      *
     C                   MOVE      *BLANKS       EDT
     C                   MOVE      *BLANKS       U#FILE
     C                   MOVE      *BLANKS       OVRDBF
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'OTPAYXL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      OTPAYXL0
     C                   MOVEL     'Y'           FIL002            1
     C                   END
      *
     C     FIL003        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV1 to share(*NO)
      *
     C                   MOVE      *BLANKS       EDT
     C                   MOVE      *BLANKS       U#FILE
     C                   MOVE      *BLANKS       OVRDBF
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'INPAY'       U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      INPAY
     C                   MOVEL     'Y'           FIL003            1
     C                   END
      *                                                                                       PNL012
     C     FIL004        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV1 to share(*NO)
      *
     C                   MOVE      *BLANKS       EDT
     C                   MOVE      *BLANKS       U#FILE
     C                   MOVE      *BLANKS       OVRDBF
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'OTPAY'       U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      OTPAY
     C                   MOVEL     'Y'           FIL004            1
     C                   END
      *                                                                                       PNL012
      *
     C                   Endsr                                                                PNL012
      *****************************************************************                       PNL012
      /EJECT                                                                                  PNL012
      *****************************************************************
      * Sr_GetCrAc - Get Credit Account
      *****************************************************************
     C     Sr_GetCrAc    Begsr
      *
      **  Get credit account for payment from
     C     P#Pref        Chain     FTCRCKV0
      *
      **  If not found then exit program
     C                   If        Not %Found
     C                   Return
     C                   Endif
      *                                                                                       PNL012
     C                   SetOff                                       88                      MAR015
      *                                                                                       MAR015
     C     P#Pref        SetLL     FTCRCKV0                                                   MAR015
     C     P#Pref        ReadE     FTCRCKV0                               88                  MAR015
      *                                                                                       MAR015
     C                   DoW       *In88 <> '1'                                               MAR015
     C                   Eval      CRDCKC  = 'Y'                                              PNL012
     C                   Update    @CRCKV0                                                    PNL012
     C     P#Pref        ReadE     FTCRCKV0                               88                  MAR015
     C                   EndDo                                                                MAR015
      *                                                                                       PNL012
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Sr_UpdCrAc - Update Credit Check File
      *****************************************************************
     C     Sr_UpdCrAc    Begsr
      *
      **  Initialise work fields
     C*****              Eval      ##CRBrca = CRCBRC                                          MAR012
     C*****              Eval      ##CRCust = CRCCUS                                          MAR012
     C*****              Eval      ##CRCcy  = CRCCCY                                          MAR012
     C*****              Eval      ##CRAcod = CRCACD                                          MAR012
     C*****              Eval      ##CRAcsq = CRCASQ                                          MAR012
     C                   MoveL     CRCBRC        ##CRBrca          3                          MAR012
     C                   MoveL     CRCCUS        ##CRCust          6                          MAR012
     C                   MoveL     CRCCCY        ##CRCcy           3                          MAR012
     C                   MoveL     CRCACD        ##CRAcod          4                          MAR012
     C                   MoveL     CRCASQ        ##CRAcsq          2                          MAR012
      *                                                                                       MAR012
     C                   Eval      ##PREF = P#PREF
      *                                                                                       MAR013
      **  Retrieve payment details                                                            MAR013
     C                   If        (%Subst(##PREF:12:2) = 'OP')                               MAR013
     C     ##PREF        Chain     OTPAYXDF                                                   MAR013
     C                   Else                                                                 MAR013
     C     ##PREF        Chain     INPAYXDF                                                   MAR013
     C                   EndIf                                                                MAR013
      *                                                                                       MAR012
      **  Retrieve payment details                                                            MAR012
     C                   If        (%Subst(##PREF:12:2) = 'OP')                               MAR012
     C     ##PREF        Chain     OTPAY                                                      MAR012
     C                   Else                                                                 MAR012
     C     ##PREF        Chain     INPAY                                                      MAR012
     C                   EndIf                                                                MAR012
      *                                                                                       MAR012
      ** Save Settle Amount including charges.                                                MAR012
     C                   Z-ADD     PYAM          #SettleAmount    15 0                        MAR012
      *                                                                                       MAR012
     C                   If        (%Subst(##PREF:12:2) = 'OP')                               MAR012
     C                             And ADDC = 'D'                                             MAR012
     C*****                        And CDRO = 0                                              MD31937
     C                             And CDRO = *Blanks                                        MD31937
     C                   Sub       TRCM          #SettleAmount                                MAR012
     C                   Sub       TXCH          #SettleAmount                                MAR012
     C                   Sub       CQCH          #SettleAmount                                MAR012
     C                   Sub       CSTA          #SettleAmount                                MAR012
     C                   Sub       SPCH          #SettleAmount                                MAR012
     C                   Sub       OPVATT        #SettleAmount                                MAR012
     C                   Sub       MISC01        #SettleAmount                                MAR012
     C                   Sub       MISC02        #SettleAmount                                MAR012
     C                   Sub       MISC03        #SettleAmount                                MAR012
     C                   Sub       MISC04        #SettleAmount                                MAR012
     C                   Sub       MISC05        #SettleAmount                                MAR012
     C                   Sub       SWSCHG        #SettleAmount                                MAR012
     C                   Add       OPRCRM        #SettleAmount                                MAR012
     C                   EndIf                                                                MAR012
     C                   If        (%Subst(##PREF:12:2) = 'IN')                               MAR012
     C                             And ADDC = 'D'                                             MAR012
     C*****                        And CDRO = 0                                              MD31937
     C                             And CDRO = *Blanks                                        MD31937
     C                   Sub       TRCM          #SettleAmount                                MAR012
     C                   Sub       TXCH          #SettleAmount                                MAR012
     C                   Sub       CQCH          #SettleAmount                                MAR012
     C                   Sub       ADCH          #SettleAmount                                MAR012
     C                   Sub       TLCH          #SettleAmount                                MAR012
     C                   Sub       MSCH          #SettleAmount                                MAR012
     C                   Sub       MSC01         #SettleAmount                                MAR012
     C                   Sub       MSC02         #SettleAmount                                MAR012
     C                   Sub       MSC03         #SettleAmount                                MAR012
     C                   Sub       MSC04         #SettleAmount                                MAR012
     C                   Sub       MSC05         #SettleAmount                                MAR012
     C                   Sub       INVATT        #SettleAmount                                MAR012
     C                   EndIf                                                                MAR012
      *
      **  Key list for chain to credit check file
     C     K2CRCK        Klist
     C                   Kfld                    ##CRBrca
     C                   Kfld                    ##CRCust
     C                   Kfld                    ##CRCcy
     C                   Kfld                    ##CRAcod
     C                   Kfld                    ##CRAcsq
      *
      *
      ** Position credit check file where DR account on other
      ** payments is same as CR account on payment being processed
     C     K2CRCK        Setll     FTCRCKV2
      *
      ** Read through credit check file
     C     *In89         Doueq     *On
      *
      ** Read credit check details
     C     K2CRCK        Reade     FTCRCKV2                               89
      *
      **  Do not process if no more records
     C***********        If        Not %Found                                                 235224
     C     *IN89         Ifeq      *On                                                        235224
     C                   Leave
     C                   Endif
      *
      **  Clear parameters for call of FTP780
     C                   Clear                   P@IDTA
     C                   Clear                   P@ODTA
     C                   Clear                   SOODTA          256
      *
      ****Set first authorisation flag                                                        MAR012
     C*****              Eval      P@AUTH  =  *Blanks                                         MAR012
     C*****              If        AUP2 = *Blanks                                             MAR012
     C*****              Eval      P@AUTH  =  'N'                                             MAR012
     C*****              Else                                                                 MAR012
     C*****              Eval      P@AUTH  =  'Y'                                             MAR012
     C*****              Endif                                                                MAR012
      *                                                                                       MAR012
      **  Retrieve payment details                                                            MAR012
     C                   If        (%Subst(CRPREF:12:2) = 'OP')                               MAR012
     C     CRPREF        Chain     OTPAY                                                      MAR012
     C                   Else                                                                 MAR012
     C     CRPREF        Chain     INPAY                                                      MAR012
     C                   EndIf                                                                MAR012
      *                                                                                       MAR012
     C                   If        %Found                                                     MAR012
     C                             And (AUIN <> 'Y')                                          MAR012
      *                                                                                       MAR012
     C                   Eval      PITP1 = 'G'                                                MAR012
     C                   Eval      PIPDTE = SLDT                                              MAR012
     C                   Eval      PICCY  = SMCY                                              MAR012
     C                   Eval      PIAMNT = CRSMAM - #SettleAmount                            MAR012
     C                   If        PIAMNT < 0                                                 MAR012
     C                   Eval      PIAMNT = 0                                                 MAR012
     C                   EndIf                                                                MAR012
     C                   Eval      PIPREF = CRPREF                                            MAR012
     C                   Eval      PIPTYP = %Subst(CRPREF:12:2)                               MAR012
     C                   Eval      PIBRCB = CRBRCA                                            MAR012
     C                   Eval      %Subst(PIPRY1:1:6) = CRCNUM                                MAR012
     C                   Eval      %Subst(PIPRY1:7:3) = CRCCY                                 MAR012
     C                   Eval      %Subst(PIPRY1:10:4) = CRACOD                               MAR012
     C                   Eval      %Subst(PIPRY1:14:2) = CRACSQ                               MAR012
     C                   Eval      %Subst(PIPRY1:16:3) = CRBRCA                               MAR012
      *****                                                                                   MAR012
      ****Get payment details                                                                 MAR012
     C*****              Select                                                               MAR012
      *****                                                                                   MAR012
     C*****##PTYP        Wheneq    'IN'                                                       MAR012
     C*****P#PREF        Chain(n)  INPAY                                                      MAR012
     C*****              If        %Found                                                     MAR012
     C*****P#PREF        Chain     INPAYXL0                                                   MAR012
     C*****              Eval      PITP1  =  SNTP                                             MAR012
     C*****              Eval      PIPRY1 =  SND1                                             MAR012
     C*****              Eval      PIBRC1 =  *BLANKS                                          MAR012
     C*****              Eval      PITP2  =  INRCRT                                           MAR012
     C*****              Eval      PIPRY2 =  INRCO1                                           MAR012
     C*****              Eval      PIBRC2 =  *BLANKS                                          MAR012
     C*****              Eval      PITP3  =  INTRIT                                           MAR012
     C*****              Eval      PIPRY3 =  INTRIB                                           MAR012
     C*****              Eval      PIBRC3 =  *BLANKS                                          MAR012
     C*****              Endif                                                                MAR012
      *****                                                                                   MAR012
     C*****##PTYP        Wheneq    'OP'                                                       MAR012
     C*****P#PREF        Chain(n)  OTPAY                                                      MAR012
     C*****              If        %Found                                                     MAR012
     C*****              Eval      PITP1  =  ORCT                                             MAR012
     C*****              Eval      PIPRY1 =  ORC1                                             MAR012
     C*****              Eval      PIBRC1 =  *BLANKS                                          MAR012
     C*****              Eval      PITP2  =  ORBT                                             MAR012
      *****                                                                             EMRMK1MAR012
     C*****OrcT          IfEq      'P'                                                  EMRMK1MAR012
     C*****              MoveL     ORC1          @@ORC15          15                    EMRMK1MAR012
     C*****              Move      @@ORC15       PIBRC1                                 EMRMK1MAR012
     C*****              EndIf                                                          EMRMK1MAR012
      *****                                                                             EMRMK1MAR012
     C*****OrcT          IfEq      'R'                                                  EMRMK1MAR012
     C*****              MoveL     ORC1          @@ORC10          10                    EMRMK1MAR012
     C*****              CALL      'AOACCTR0'                                           EMRMK1MAR012
     C*****              PARM                    P@RTCD            7                    EMRMK1MAR012
     C*****              PARM      '*KEY   '     P@OPTN            7                    EMRMK1MAR012
     C*****              PARM      @@ORC10       P@RETL           10                    EMRMK1MAR012
     C*****              PARM      *Blanks       P@CNUM            6                    EMRMK1MAR012
     C*****              PARM      *Blanks       P@CUCD            3                    EMRMK1MAR012
     C*****              PARM      *Blanks       P@ACCD            4                    EMRMK1MAR012
     C*****              PARM      *Blanks       P@ACSQ            2                    EMRMK1MAR012
     C*****              PARM      *Blanks       P@BRCA            3                    EMRMK1MAR012
     C*****              PARM                    ACCINF                                 EMRMK1MAR012
     C*****              EndIf                                                          EMRMK1MAR012
      *****                                                                             EMRMK1MAR012
     C*****P@RTCD        IfEq      *Blanks                                              EMRMK1MAR012
     C*****              MoveL     AccBrca       PIBRC1                                 EMRMK1MAR012
     C*****              EndIf                                                          EMRMK1MAR012
      *****                                                                             EMRMK1MAR012
     C*****              Movel     ORBK          PIPRY2                                       MAR012
     C*****              Eval      PIBRC2 =  ORBB                                             MAR012
     C*****              Eval      PITP3  =  *BLANKS                                          MAR012
     C*****              Eval      PIPRY3 =  *BLANKS                                          MAR012
     C*****              Eval      PIBRC3 =  *BLANKS                                          MAR012
     C*****              Endif                                                                MAR012
      *****                                                                                   MAR012
     C*****              Endsl                                                                MAR012
      *****                                                                                   MAR012
     C*****              Eval      PICCY  =  SMCY                                             MAR012
     C*****              Eval      PIAMNT =  SMAM                                             MAR012
     C*****              Eval      PIPDTE =  SLDT                                             MAR012
     C*****              Eval      PIPREF =  PREF                                             MAR012
     C*****              Eval      PIPTYP =  PYTP                                             MAR012
     C*****              Eval      PIBRCB =  BRCA                                             MAR012
      *
      **  Call validator
     C                   Call      'FTP780'
     C                   Parm                    P@RTCE            7
     C                   Parm      'NO '         P@DSP             3
     C                   Parm                    P@IDTA
     C                   Parm                    P@ODTA
     C                   Parm                    P@AUTH
      *
      **  Set up returned data
     C                   Eval      SOODTA  =  P@ODTA
      *
      **  If okay then update
     C***********        If            P@RTCE <> '*NOCHK '                                    233571
     C***********                  and P@RTCE <> *BLANKS                                      233571
     C***********                  and P@RTCE <> '*OVER  '                                    233571
     C***********                  and P@RTCE <> '*EXCEED'                                    233571
     C*****              If            P@RTCE = '*NOCHK '                               233571PNL012
     C*****                        or  P@RTCE = *BLANKS                                 233571PNL012
     C                   If            P@RTCE = *BLANKS                                       PNL012
      *****                                                                                   MAR012
      ****Update payment details                                                              MAR012
     C*****              Select                                                               MAR012
      *****                                                                                   MAR012
     C*****##PTYP        Wheneq    'IN'                                                       MAR012
     C*****P#PREF        Chain     INPAY                                                      MAR012
     C*****              Eval      AUIN  = 'Y'                                                MAR012
     C*****              Eval      AUP2 = AUP1                                                MAR012
     C*****              if        AUP2 = *blanks                                       PNL012MAR012
     C*****              eval      AUP1 = inusr1                                        PNL012MAR012
     C*****              eval      AUP2 = inusr1                                        PNL012MAR012
     C*****              endif                                                          PNL012MAR012
     C*****              Update    INPAYDDF                                                   MAR012
      *****                                                                                   MAR012
     C*****##PTYP        Wheneq    'OP'                                                       MAR012
     C*****P#PREF        Chain     OTPAY                                                      MAR012
     C*****              Eval      AUIN  = 'Y'                                                MAR012
     C*****              Eval      AUP2 = AUP1                                                MAR012
     C*****              if        AUP2 = *blanks                                       PNL012MAR012
     C*****              eval      AUP1 = inusr1                                        PNL012MAR012
     C*****              eval      AUP2 = inusr1                                        PNL012MAR012
     C*****              endif                                                          PNL012MAR012
     C*****              Update    OTPAYDDF                                                   MAR012
     C*****              Endsl                                                                MAR012
      *                                                                                       MAR012
      **  Update payment details                                                              MAR012
      *                                                                                       MARCIN
     C     MSGKEY        KList                                                                MARCIN
     C                   KFld                    @FTMSGR                                      MARCIN
     C                   KFld                    @FTKPRT                                      MARCIN
      *                                                                                       MARCIN
     C                   Move      'N'           UpdFlg            1                          MARCIN
     C                   If        (@FTMSGR <> 0) And (@FTKPRT <> 0)                          MARCIN
     C     MSGKEY        Chain     @INFTL0                                                    MARCIN
     C                   If        %Found                                                     MARCIN
     C                   Eval      UpdFlg = 'Y'                                               MARCIN
     C                   Else                                                                 MARCIN
     C                   ExSr      *Pssr                                                      MARCIN
     C                   EndIf                                                                MARCIN
     C                   EndIf                                                                MARCIN
      *                                                                                       MARCIN
     C                   If        (%Subst(CRPREF:12:2) = 'OP')                               MAR012
      * Authorise outgoing payment                                                            MAR012
     C                   Eval      AUIN = 'Y'                                                 MAR012
     C                   Eval      AUP1 = INUSR1                                              MAR012
     C                   Eval      AUP2 = INUSR1                                              MAR012
     C                   Update    OTPAYDDF                                                   MAR012
     C                   MoveL     'OP'          InOp              2                          PNL004
     C                   ExSr      PrepPNL004                                                 PNL004
     C                   Eval      FTOTFG = 'MIN0032'                                         MARCIN
     C                   Else                                                                 MAR012
      * otherwise, authorise incoming                                                         MAR012
     C                   Eval      AUIN = 'Y'                                                 MAR012
     C                   Eval      AUP1 = INUSR1                                              MAR012
     C                   Eval      AUP2 = INUSR1                                              MAR012
     C                   Update    INPAYDDF                                                   MAR012
     C                   MoveL     'IN'          InOp              2                          PNL004
     C                   ExSr      PrepPNL004                                                 PNL004
     C                   Eval      FTINFG = 'MIN0032'                                         MARCIN
     C                   EndIf                                                                MAR012
     C                   ExSr      ExecPNL004                                                 PNL004
      *                                                                                       MARCIN
     C                   If        UpdFlg = 'Y'                                               MARCIN
     C                   Update    @INFTL0                                                    MARCIN
     C                   EndIf                                                                MARCIN
      *                                                                                       MAR012
     C                   EndIf                                                                MAR012
      *
      **  Update Dr Check Complete flag
     C*****              Eval      CRDRCK  = 'Y'                                              PNL012
     C                   Eval      CRDCKC  = 'Y'                                              PNL012
     C                   Update    @CRCKV2
      *
      **  Commit changes                                                                      PNL012
     C*****              Commit                                                               PNL012
      *
     C                   Endif
      *
     C                   Enddo
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Error Processing Routine
      *****************************************************************
     C     *PSSR         Begsr
      *
      ** Produe dump and terminate program
     C                   If        ##ERROR <> 'Y'
     C                   Dump
     C                   Eval      ##ERROR = 'Y'
     C                   Eval      P#Return = '*ERROR'
     C                   Eval      *InU7 = *on
     C                   Eval      *InU8 = *on
     C                   Eval      *InLR = *on
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
      * File and Program Error Processing
      *
     C*COPY MECPYSRC,SRERRC_ILE      *MBR INCLUDED BELOW*
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SRERRC_ILE - Midas Error Processing - 'C' Specs              *
      *                                                               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CSW200  *CREATE    Date 03AUG00               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW200 - Swift 2000 Changes.                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      *  Dump program
      *
     C                   DUMP
     C                   ROLBK                                          90
      *
      *  If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
      *
     C                   MOVEL     'Y'           @@FILE            1
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     21
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   END
      *
     C                   MOVEL     ##ERST        ERKEY
     C                   Z-ADD     999           ERERNB
     C                   MOVEL     ##ERFL        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      * Get message for sending and place in msg field
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MEM5002'     #MSGID
     C                   PARM      'MIDAS   '    #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      * Send message
      *
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  Fill LDA with error data
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      *  Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************                       PNL004
      *                                                               *                       PNL004
      *  ExecPNL004:                                                  *                       PNL004
      *****************************************************************                       PNL004
     CSR   ExecPNL004    BegSr                                                                PNL004
     C     PNL004        IFEQ      'Y'                                                        PNL004
      *                                                                                       PNL004
     C                   MoveL     Pref          PPref                                        PNL004
     C                   MoveL     PAYMSG        O#1000                                       PNL004
      *                                                                                       PNL004
     C                   Call      'ZEXTRACT'                                                 PNL004
     C                   Parm      *BLANK        @RTCD                                        PNL004
     C                   Parm      'FT'          O#MODI            2                          PNL004
     C                   Parm                    O#TNRF           20                          PNL004
     C                   Parm      'N'           O#REVI            1                          PNL004
     C                   Parm                    O#1000                                       PNL004
      *                                                                                       PNL004
     C     @RTCD         IfNE      *Blanks                                                    PNL004
     C                   MoveL     'ZEXTRACT'    DBFILE                                       PNL004
     C                   MoveL     '501'         DBASE                                        PNL004
     C                   MoveL     *Blank        DBKEY                                        PNL004
     C                   ExSr      *Pssr                                                      PNL004
     C                   EndIf                                                                PNL004
      *                                                                                       PNL004
     C                   ENDIF                                                                PNL004
     CSR                 EndSr                                                                PNL004
     C/EJECT                                                                                  PNL004
      *****************************************************************                       PNL004
      *                                                               *                       PNL004
      *  PrepPNL004:                                                  *                       PNL004
      *****************************************************************                       PNL004
     CSR   PrepPNL004    BegSr                                                                PNL004
     C     PNL004        IfEq      'Y'                                                        PNL004
     C                   MOVEL     'FT'          O#MODI                                       PNL004
     C                   MOVEL     PREF          O#TNRF                                       PNL004
     C                   MOVEL     PYTP          O#TRYP                                       PNL004
      *                                                                                       PNL004
     C                   CALL      'AOURSAU0'                                                 PNL004
     C                   PARM      *BLANK        @RTCD                                        PNL004
     C                   PARM                    O#MODI            2                          PNL004
     C                   PARM                    O#TNRF           20                          PNL004
     C                   PARM                    O#VUDT            5 0                        PNL004
     C                   PARM                    O#ASEQ            3 0                        PNL004
     C                   PARM                    O#EVTP            2                          PNL004
     C                   PARM                    O#TRYP            2                          PNL004
     C                   PARM                    O#SBTP            2                          PNL004
      *                                                                                       PNL004
     C     @RTCD         IFEQ      '*ERROR*'                                                  PNL004
     C     *LOCK         IN        LDA                                                        PNL004
     C                   MOVEL     'AOURSAU0'    DBPGM                                        PNL004
     C                   Z-ADD     103           DBASE                                        PNL004
     C                   MOVEL     '*CALL'       DBKEY                                        PNL004
     C                   OUT       LDA                                                        PNL004
     C                   SETON                                        U7U8LR                  PNL004
     C                   DUMP                                                                 PNL004
     C                   RETURN                                                               PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
      ***  Fields for ZEXTRACT Routine                                                        PNL004
      *                                                                                       PNL004
     C                   MOVE      *BLANKS       PAYMSG                                       PNL004
      *                                                                                       PNL004
      ***  depending on transaction, Find Pay and Settlement accounts                         PNL004
      *                                                                                       PNL004
     C     InOp          IfEq      'OP'                                                       PNL004
      *                                                                                       PNL004
      ***  Pay Account                                                                        PNL004
      *                                                                                       PNL004
     C     SNCT          IFNE      *BLANKS                                                    PNL004
     C                   MOVEL     SNCT          @TYPEP                                       PNL004
     C                   MOVEL     SNCO          @ACCTP                                       PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL     DSTT          @TYPEP                                       PNL004
     C                   MOVEL     DST1          @ACCTP                                       PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
      ***  Settlement Account                                                                 PNL004
      *                                                                                       PNL004
     C     ORBT          IFNE      *BLANKS                                                    PNL004
     C                   MOVEL     ORBT          @TYPES                                       PNL004
     C                   MOVEL     ORBK          @ACCTS                                       PNL004
     C     @TYPES        IFEQ      'R'                                                        PNL004
     C*****ORBK          DIV       100           WRK10N           10 0               PNL004  MD31937
     C*****              MOVEL(P)  WRK10N        @ACCTS                              PNL004  MD31937
     C                   MOVEL     ORBK          WRK10            10                         MD31937
     C                   MOVEL     WRK10         @ACCTS                                      MD31937
     C                   ENDIF                                                                PNL004
     C                   MOVEL     ORBB          @BRCAS                                       PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL     ORCT          @TYPES                                       PNL004
     C                   MOVEL     ORC1          @ACCTS                                       PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C                   Else                                                                 PNL004
      *                                                                                       PNL004
      ***  Pay Account                                                                        PNL004
      *                                                                                       PNL004
     C     ACBT          IFNE      *BLANKS                                                    PNL004
     C                   MOVEL     ACBT          @TYPEP                         1Char         PNL004
     C                   MOVEL     ACBK          @ACCTP                         18char        PNL004
     C                   MOVEL     ACBB          @BRCAP                         3char         PNL004
     C                   ELSE                                                                 PNL004
     C     BNCT          IFNE      'I'                                          not IBAN      PNL004
     C                   MOVEL     BNCT          @TYPEP                                       PNL004
     C                   MOVEL     BNC1          @ACCTP                                       PNL004
     C                   ELSE                                                                 PNL004
     C     34            SUBST     BNC1:2        @IBAN                                        PNL004
     C                   MOVE      *BLANKS       DSSDY                                        PNL004
      *                                                                                       PNL004
     C                   CALL      'AOIBANR4'                                                 PNL004
     C                   PARM      *BLANKS       @RTCD                                        PNL004
     C                   PARM      '*KEY   '     @OPTN                                        PNL004
     C                   PARM                    @IBAN            34                          PNL004
     C     P@ACCT        PARM                    DSSDY                                        PNL004
      *                                                                                       PNL004
     C     @RTCD         IFEQ      *BLANKS                                                    PNL004
     C                   MOVE      'G'           @TYPEP                                       PNL004
     C                   Z-ADD     CNUM#1        @CNU1                                        PNL004
     C                   MOVE      CCY#1         @CCY1                                        PNL004
     C                   Z-ADD     ACOD#1        @ACD1                                        PNL004
     C                   Z-ADD     ACSQ#1        @ACS1                                        PNL004
     C                   MOVE      BRCA#1        @BRC1                                        PNL004
     C                   ENDIF                                                                PNL004
     C                   ENDIF                                                                PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
      ***  Settlement account                                                                 PNL004
      *                                                                                       PNL004
     C     INTRIT        IFNE      *BLANKS                                                    PNL004
     C     INTRIT        IFNE      'I'                                                        PNL004
     C                   MOVEL     INTRIT        @TYPES                                       PNL004
     C                   MOVEL     INTRIB        @ACCTS                                       PNL004
     C                   ELSE                                                                 PNL004
      *                                                                                       PNL004
     C                   MOVEL     INTRIB        @IBAN            34                          PNL004
     C                   MOVE      *BLANKS       DSSDY                                        PNL004
      *                                                                                       PNL004
     C                   CALL      'AOIBANR4'                                                 PNL004
     C                   PARM      *BLANKS       @RTCD                                        PNL004
     C                   PARM      '*KEY   '     @OPTN                                        PNL004
     C                   PARM                    @IBAN            34                          PNL004
     C     P@ACCT        PARM                    DSSDY                                        PNL004
      *                                                                                       PNL004
     C     @RTCD         IFEQ      *BLANKS                                                    PNL004
     C                   MOVE      'G'           @TYPES                                       PNL004
     C                   Z-ADD     CNUM#1        @CNU2                                        PNL004
     C                   MOVE      CCY#1         @CCY2                                        PNL004
     C                   Z-ADD     ACOD#1        @ACD2                                        PNL004
     C                   Z-ADD     ACSQ#1        @ACS2                                        PNL004
     C                   MOVE      BRCA#1        @BRC2                                        PNL004
     C                   ENDIF                                                                PNL004
     C                   ENDIF                                                                PNL004
     C                   ELSE                                                                 PNL004
     C     INRCRT        IFNE      *BLANKS                                                    PNL004
      *                                                                                       PNL004
     C     INRCRT        IFNE      'I'                                                        PNL004
     C                   MOVEL     INRCRT        @TYPES                                       PNL004
     C                   MOVEL     INRCO1        @ACCTS                                       PNL004
     C                   ELSE                                                                 PNL004
     C     34            SUBST     INRCO1:2      @IBAN            34                          PNL004
     C                   MOVE      *BLANKS       DSSDY                                        PNL004
      *                                                                                       PNL004
     C                   CALL      'AOIBANR4'                                                 PNL004
     C                   PARM      *BLANKS       P@RTCD            7                          PNL004
     C                   PARM      '*KEY   '     P@OPTN            7                          PNL004
     C                   PARM                    @IBAN                                        PNL004
     C     P@ACCT        PARM                    DSSDY                                        PNL004
      *                                                                                       PNL004
     C     P@RTCD        IFEQ      *BLANKS                                                    PNL004
     C                   Z-ADD     CNUM#1        @CNU2                                        PNL004
     C                   MOVE      CCY#1         @CCY2                                        PNL004
     C                   Z-ADD     ACOD#1        @ACD2                                        PNL004
     C                   Z-ADD     ACSQ#1        @ACS2                                        PNL004
     C                   MOVE      BRCA#1        @BRC2                                        PNL004
     C                   ENDIF                                                                PNL004
     C                   ENDIF                                                                PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL     SNTP          @TYPES                                       PNL004
     C                   MOVEL     SND1          @ACCTS                                       PNL004
     C                   ENDIF                                                                PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C                   EndIf                                                                PNL004
      *                                                                                       PNL004
     C                   MOVEL     'FT'          O#MODI                                       PNL004
     C                   MOVEL(P)  PREF          O#TNRF                                       PNL004
     C                   Z-ADD     0             O#VUDT                                       PNL004
     C                   Z-ADD     0             O#ASEQ                                       PNL004
     C                   MOVE      *BLANKS       O#EVTP                                       PNL004
     C                   MOVE      PYTP          O#TRYP                                       PNL004
     C                   MOVEL     *BLANKS       O#SBTP                                       PNL004
      *                                                                                       PNL004
     C                   MOVEL     PREF          PPREF                                        PNL004
     C     InOp          IfEq      'OP'                                                       PNL004
     C                   MOVE      ORECI         PRCST                                        PNL004
     C                   Else                                                                 PNL004
     C                   MOVE      IRECI         PRCST                                        PNL004
     C                   EndIf                                                                PNL004
     C                   MOVEL     PYTP          PPYTP                                        PNL004
     C                   MOVEL     PYST          PPYST                                        PNL004
      *                                                                                       PNL004
     C                   MOVEL     SLDT          ZMDAY                               Sett. datPNL004
     C                   CALL      'ZM0065'                                                   PNL004
     C                   PARM                    ZMDAY             5 0                        PNL004
     C                   PARM                    ZSDATE            6                          PNL004
     C                   PARM                    PSVDT                                        PNL004
      *                                                                                       PNL004
     C                   MOVE      SMCY          PSCCY                                        PNL004
      *                                                                                       PNL004
     C                   Z-ADD     SMAM          ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM      SMCY          ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C     SMAM          IFLT      0                                                          PNL004
     C     '-'           CAT(P)    ZSAMNT:0      PSAMT                                        PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL(P)  ZSAMNT        PSAMT                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C                   MOVEL     SETSID        PSSAM                          Settl. AccountPNL004
      *                                                                                       PNL004
     C                   CALL      'ZM0065'                                                   PNL004
     C                   PARM      PVDT          ZMDAY             5 0                        PNL004
     C                   PARM                    ZSDATE            6                          PNL004
     C                   PARM                    ZSDATC            8                          PNL004
     C                   MOVE      ZSDATC        PPVDT                                        PNL004
      *                                                                                       PNL004
     C                   MOVE      PCCY          PPCCY                                        PNL004
      *                                                                                       PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM      PYAM          ZAMNT            13 0                        PNL004
     C                   PARM      PCCY          ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
      *                                                                                       PNL004
     C     PYAM          IFLT      0                                                          PNL004
     C     '-'           CAT(P)    ZSAMNT:0      PPAMT                                        PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL(P)  ZSAMNT        PPAMT                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C                   MOVEL     PAYSID        PPSAM                          Pay account   PNL004
      *                                                                                       PNL004
     C                   CALL      'ZM0010'                                                   PNL004
     C                   PARM      RATE          ZINRT            11 7                        PNL004
     C                   PARM                    ZSINRT           12                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSINRT        PCXRT                                        PNL004
      *                                                                                       PNL004
     C     InOp          IfEq      'OP'                                         Only for OP   PNL004
     C                   MOVEL     RPAY          PRPIN                                        PNL004
     C                   MOVEL     PAYF          PRPFR                                        PNL004
     C     DYIM          IFNE      0                                                          PNL004
     C                   MOVEL     DYIM          PRPDY                                        PNL004
     C                   ENDIF                                                                PNL004
     C                   EndIf                                                                PNL004
      *                                                                                       PNL004
     C                   CALL      'ZM0065'                                                   PNL004
     C                   PARM      NPDT          ZMDAY             5 0                        PNL004
     C                   PARM                    ZSDATE            6                          PNL004
     C                   PARM                    PNPDT             8                          PNL004
      *                                                                                       PNL004
     C                   CALL      'ZM0065'                                                   PNL004
     C                   PARM      FDAT          ZMDAY             5 0                        PNL004
     C                   PARM                    ZSDATE            6                          PNL004
     C                   PARM                    PFPDT             8                          PNL004
      *                                                                                       PNL004
     C     InOp          IfEq      'OP'                                         Only for OP   PNL004
     C                   MOVEL     ACB1          PACB1                                        PNL004
     C                   MOVEL     ACB2          PACB2                                        PNL004
     C                   MOVEL     ACB3          PACB3                                        PNL004
     C                   MOVEL     ACB4          PACB4                                        PNL004
     C                   MOVEL     ACB5          PACB5                                        PNL004
      *                                                                                       PNL004
     C                   MOVEL     BNC1          PBOC1                                        PNL004
     C                   MOVEL     BNC2          PBOC2                                        PNL004
     C                   MOVEL     BNC3          PBOC3                                        PNL004
     C                   MOVEL     BNC4          PBOC4                                        PNL004
     C                   ELSE                                                                 PNL004
     C                   MOVEL     ORC1          PBOC1                                        PNL004
     C                   MOVEL     ORC2          PBOC2                                        PNL004
     C                   MOVEL     ORC3          PBOC3                                        PNL004
     C                   MOVEL     ORC4          PBOC4                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C                   MOVEL     DTP1          PDTP1                                        PNL004
     C                   MOVEL     DTP2          PDTP2                                        PNL004
     C                   MOVEL     DTP3          PDTP3                                        PNL004
     C                   MOVEL     DTP4          PDTP4                                        PNL004
      *                                                                                       PNL004
     C                   MOVEL     RLPR          PRLPR                                        PNL004
     C                   MOVEL     DTCH          PDTCH                                        PNL004
      *                                                                                       PNL004
      ***  use display fields for setup of the following :                                    PNL004
      ***  in Charge CCY                                                                      PNL004
      *                                                                                       PNL004
     C     InOp          IfEq      'OP'                                                       PNL004
     C                   MOVEL     OPCHGC        ZCCY                                         PNL004
     C                   Else                                                                 PNL004
     C                   MOVEL     INCHGC        ZCCY                                         PNL004
     C                   EndIf                                                                PNL004
     C     DUMA1         IFNE      0                                                          PNL004
     C                   Z-ADD     DUMA1         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PTRCM                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA2         IFNE      0                                                          PNL004
     C                   Z-ADD     DUMA2         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PTXCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA3         IFNE      0                                                          PNL004
     C                   Z-ADD     DUMA3         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PCQCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA4         IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     DUMA4         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PCSTA                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     SWSCCC        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     SWSCCC        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PSWCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA5         IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     DUMA5         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PSPCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA4         IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     DUMA4         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PADCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA5         IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     DUMA5         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PTLCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     DUMA6         IFNE      0                                                          PNL004
     C                   Z-ADD     DUMA6         ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSCH                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     MISCC1        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     MISCC1        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC1                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     MISCC2        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     MISCC2        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC2                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     MISCC3        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     MISCC3        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC3                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     MISCC4        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     MISCC4        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC4                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     MISCC5        IFNE      0                                                          PNL004
     C     InOp          AndEq     'OP'                                                       PNL004
     C                   Z-ADD     MISCC5        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC5                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     CMSC01        IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     CMSC01        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC1                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     CMSC02        IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     CMSC02        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                   PNL004              PNL004
     C                   MOVEL     ZSAMNT        PMSC2                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                   PNL004              PNL004
     C     CMSC03        IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     CMSC03        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC3                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     CMSC04        IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     CMSC04        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC4                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       PNL004
     C     CMSC05        IFNE      0                                                          PNL004
     C     InOp          AndNe     'OP'                                                       PNL004
     C                   Z-ADD     CMSC05        ZAMNT                                        PNL004
     C                   CALL      'ZM0040'                                                   PNL004
     C                   PARM                    ZAMNT            13 0                        PNL004
     C                   PARM                    ZCCY              3                          PNL004
     C                   PARM                    ZSAMNT           17                          PNL004
     C                   PARM                    ZSCCY             3                          PNL004
     C                   PARM                    ZERR              1                          PNL004
     C                   PARM                    ZSWDPC            1                          PNL004
      *                                                                                       PNL004
     C                   MOVEL     ZSAMNT        PMSC5                                        PNL004
     C                   ENDIF                                                                PNL004
      *                                                                                       CHG004
     C     InOp          Ifeq      'IN'                                                       CHG004
     C                   movel     INCHGC        PCHGC                                        CHG004
     C                   movel     PCCY          PRCCN                                        CHG004
     C                   movel     PCCY          ZCCY                                         CHG004
     C     INRCRM        Ifne      0                                                          CHG004
     C                   z-add     INRCRM        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PRCRM                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     INSCY1        PSCY1                                        CHG004
     C     INSCH1        Ifne      0                                                          CHG004
     C                   movel     INSCY1        ZCCY                                         CHG004
     C                   z-add     INSCH1        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH1                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     INSCY2        PSCY2                                        CHG004
     C     INSCH2        Ifne      0                                                          CHG004
     C                   movel     INSCY2        ZCCY                                         CHG004
     C                   z-add     INSCH2        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH2                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     INSCY3        PSCY3                                        CHG004
     C     INSCH3        Ifne      0                                                          CHG004
     C                   movel     INSCY3        ZCCY                                         CHG004
     C                   z-add     INSCH3        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH3                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     INSCY4        PSCY4                                        CHG004
     C     INSCH4        Ifne      0                                                          CHG004
     C                   movel     INSCY4        ZCCY                                         CHG004
     C                   z-add     INSCH4        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH4                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     INSCY5        PSCY5                                        CHG004
     C     INSCH5        Ifne      0                                                          CHG004
     C                   movel     INSCY5        ZCCY                                         CHG004
     C                   z-add     INSCH5        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH5                                        CHG004
     C                   endif                                                                CHG004
     C                   movel     BNC1          PBNC1                                        CHG004
      *                                                                                       CHG004
     C                   ELSE                                                                 CHG004
      *                                                                                       CHG004
     C                   movel     OPCHGC        PCHGC                                        CHG004
     C                   movel     PCCY          PRCCN                                        CHG004
     C                   movel     PCCY          ZCCY                                         CHG004
     C     OPRCRM        Ifne      0                                                          CHG004
     C                   z-add     OPRCRM        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PRCRM                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     OPSCC1        PSCY1                                        CHG004
     C     OPSCH1        Ifne      0                                                          CHG004
     C                   movel     OPSCC1        ZCCY                                         CHG004
     C                   z-add     OPSCH1        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH1                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     OPSCC2        PSCY2                                        CHG004
     C     OPSCH2        Ifne      0                                                          CHG004
     C                   movel     OPSCC2        ZCCY                                         CHG004
     C                   z-add     OPSCH2        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH2                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     OPSCC3        PSCY3                                        CHG004
     C     OPSCH3        Ifne      0                                                          CHG004
     C                   movel     OPSCC3        ZCCY                                         CHG004
     C                   z-add     OPSCH3        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH3                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     OPSCC4        PSCY4                                        CHG004
     C     OPSCH4        Ifne      0                                                          CHG004
     C                   movel     OPSCC4        ZCCY                                         CHG004
     C                   z-add     OPSCH4        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH4                                        CHG004
     C                   endif                                                                CHG004
      *                                                                                       CHG004
     C                   movel     OPSCC5        PSCY5                                        CHG004
     C     OPSCH5        Ifne      0                                                          CHG004
     C                   movel     OPSCC5        ZCCY                                         CHG004
     C                   z-add     OPSCH5        ZAMNT                                        CHG004
     C                   CALL      'ZM0040'                                                   CHG004
     C                   PARM                    ZAMNT            13 0                        CHG004
     C                   PARM                    ZCCY              3                          CHG004
     C                   PARM                    ZSAMNT           17                          CHG004
     C                   PARM                    ZSCCY             3                          CHG004
     C                   PARM                    ZERR              1                          CHG004
     C                   PARM                    ZSWDPC            1                          CHG004
      *                                                                                       CHG004
     C                   movel     ZSAMNT        PSCH5                                        CHG004
     C                   endif                                                                CHG004
     C                   movel     *Blanks       PBNC1                                        CHG004
     C                   ENDIF                                                                CHG004
      *                                                                                       PNL004
     C                   MOVEL     *BLANKS       CHGSID                                       PNL004
     C     CDRT          IFNE      *BLANKS                                                    PNL004
     C                   MOVEL     CDRT          @TYPEC                                       PNL004
     C                   MOVEL     CDRO          @ACCTC                                       PNL004
     C                   MOVEL     CDBR          @BRCAC                                       PNL004
     C                   MOVEL     BJCYCD        @CCYC                                        PNL004
     C                   ENDIF                                                                PNL004
     C                   MOVEL     CHGSID        PCDRO                                        PNL004
      *                                                                                       PNL004
     C                   MOVEL     PAYMSG        O#1000                                       PNL004
      *                                                                                       PNL004
     C                   EndIf                                                                PNL004
     CSR                 EndSr                                                                PNL004
     C/EJECT                                                                                  PNL004
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: All subroutines                                   *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5002 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Define work variables
      *
     C     *LIKE         DEFINE    ERKEY         W0KEY
     C     *LIKE         DEFINE    ERERNB        W0ERNB
     C     *LIKE         DEFINE    ERFILE        W0FILE
     C     *LIKE         DEFINE    ERPREF        W0PREF                         Primary Ref.
      *
     C     *LIKE         DEFINE    #MSGID        W0MSGD                         Msg I.D.
     C     *LIKE         DEFINE    #MSGF         W0MSGF                         Msg File
      *
     C                   Z-ADD     Q             Q                 5 0
      *
      *  Dump program
      *
     C                   DUMP
     C                   ROLBK                                          90
      *
      *  Set up the details of the message to be sent to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     21
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   END
      *
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      * Get message for message code. If the msg code or the msg file
      * have not been set up then use the defaults.
      *
     C     W0MSGD        IFEQ      *BLANKS
     C                   MOVEL     'MEM5001'     C#FMSG            7
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   END
      *
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF           10
     C                   ELSE
     C                   MOVEL     W0MSGF        C#FMSF
     C                   END
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      C#FMSG        #MSGID
     C                   PARM      C#FMSF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      * Send message
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  Fill LDA with error data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      *  Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      *****************************************************************
      * End of /COPY SRERRC_ILE                                       *
      *****************************************************************
      /EJECT
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2004
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO)
