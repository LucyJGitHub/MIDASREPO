     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*OVRF*: OVRDBF (FILE IN PROGRAM) (FILE ON SYSTEM)                  : *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP830 - FT Determine Book code defaults                     *
      *                                                               *
      *  Function:  This program defaults a book depending on the     *
      *  input specified                                              *
      *                                                               *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2003       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. ERN054             Date 19Jun2003             *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  ERN054 - Agency message changes                              *
      *                                                               *
      *****************************************************************
     F/EJECT
     FMEINCRL1  IF   E           K DISK
      *
      *  Message header for sender of message
      *
     FFTBKDFV0  IF   E           K DISK
      *
      *  FT Book code defaults
      *
     FFTLOOKV0  IF   E           K DISK
      *
      *  FT Look Up searches
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
     D  Search#        S             10A   DIM(10)
     D  SearchNbr      S              5  0
     D  KeySV          S              1A   DIM(10)
     D  Idx            S              5  0
      *
      *  Copyright
      *
     D FTLOOK        E DS                  EXTNAME(FTLOOKP0)
      * FTLOOKP0 - Look Up searches
     D  ##Search              16     25
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * SDBANKPD - Bank details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * SCSARDPD - CAR Details
      *
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  ##JOB                244    253
     D  ##WSID               244    246
     D  ##USER               254    263
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long data structure
      *
     D TranOPPrim    E DS                  EXTNAME(FTOPY1PD) PREFIX(O_)
     D TranINPrim    E DS                  EXTNAME(FTIPY1PD) PREFIX(I_)
      * Payment Details
      *
     D Values        E DS                  EXTNAME(FTBKDFP0) PREFIX(V_)
     D Keys          E DS                  EXTNAME(FTBKDFP0) PREFIX(K_)
      *
     D ##Country       S              2
     D DIGITS          C                   CONST('0123456789')
      *

     D/EJECT
      *****************************************************************
     I/EJECT
      *****************************************************************

      * Initialise
      *
     C                   If        #first =*blanks
     C                   Exsr      Initialise
     C                   Endif
      * Exit if feature not installed
     C                   If        ERN054 <> 'ERN054'
     C                   Return
     C                   Endif
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *
     C     *Entry        Plist
     C                   Parm                    RetFtp830         7
     C                   Parm                    InType            2
     C                   Parm                    InMsgr            8
     C                   Parm                    InParm         1000
     C                   Parm                    OutBook           2
      *
      *  Only do processing if pay type passed
      *
     C                   Eval      OutBook = *blanks
     C                   If        InType <> *blanks
      * Set Up Data
     C                   If        InType = 'OP'
     C                   Eval      TranOPPrim = InParm
     C                   Endif
     C                   If        InType = 'IN'
     C                   Eval      TranINPrim = InParm
     C                   Endif
     C                   Exsr      GetLookUps
     C                   Endif
      *
      *  Exit program
      *
     C                   Return
      /EJECT
      *****************************************************************
      * Get Look Up values
      *****************************************************************
     C     GetLookUps    BEGSR
      *
      * Set values to blanks
      *
     C                   Clear                   Values
      *
      * Get message header if transaction linked
      *
     C                   If        InMsgr <> *blanks and InMsgr <> '00000000'
      *
     C     KIncrl1       KLIST
     C                   Kfld                    CRMSGR
     C                   Movel     InMsgr        CRMSGR
      *
     C     KIncrl1       Chain     @INCRL1
      * If found get message charge details
     C                   If        %Found
     C                   Eval      V_BDNWRK = CRNWRK
     C                   Eval      V_BDMTPY = CRMTPY
     C                   Endif
     C                   Endif
      *
     C                   Eval      V_BDUSER = ##USER
      * Outgoing
     C                   If        InType = 'OP'
     C                   Eval      V_BDBRCA = O_SBRCA
     C                   Eval      V_BDPTYP = O_SPYTP
     C                   Eval      V_BDPYST = O_SPYST
     C                   Eval      V_BDSTMT = O_SSTTP
     C                   Eval      V_BDADDC = O_SADDC
      * If Pay and settle currencies not the same then FX
     C                   If        O_SSMCY <> O_SPCCY
     C                   Eval      V_BDFXTR = 'Y'
     C                   Else
     C                   Eval      V_BDFXTR = 'N'
     C                   Endif
     C                   Endif
      * Incoming
     C                   If        InType = 'IN'
     C                   Eval      V_BDBRCA = I_DDBRCA
     C                   Eval      V_BDPTYP = 'IN'
     C                   Eval      V_BDPYST = I_DDPYST
     C                   Eval      V_BDADDC = I_DDADDC
      * If Pay and settle currencies not the same then FX
     C                   If        I_DDSMCY <> I_DDPCCY
     C                   Eval      V_BDFXTR = 'Y'
     C                   Else
     C                   Eval      V_BDFXTR = 'N'
     C                   Endif
     C                   Endif
      *
     C                   Exsr      GetDefBook
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialise
      *****************************************************************
     C     Initialise    BEGSR
      *
      * Get bank details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       P@RTCD            7
     C                   Parm      '*FIRST '     P@OPTN            7
     C     Sdbank        Parm      *blanks       DSSDY
      *
     C                   Call      'AOSARDR0'                                   Rtv SAR
     C                   Parm      *BLANKS       P@RTCD                          Pm RtnCd
     C                   Parm      '*VERIFY'     P@OPTN                          Pm Option
     C                   Parm      'ERN054'      P@SARD            6             Pm SAR No
     C     Scsard        Parm      *blanks       DSSDY                           Pm DsFdy
      *
     C                   If        P@RTCD = *blanks
     C                   Movel     'ERN054'      ERN054            6
     C                   Endif
      *
      * Define Look Up key
     C     Klook1        Klist
     C                   Kfld                    LPKEY
     C                   Kfld                    LPSEQN
     C     Klook2        Klist
     C                   Kfld                    LPKEY
      *
     C                   Eval      LPKEY = 'Book Code '
     C                   Clear                   LPSEQN
      *
      * Look to see if specific customer search required
     C     Klook1        Setll     @Lookv0
     C     Klook2        Reade     @Lookv0                                90
     C                   If        *in90 = *off
     C                   Eval      SearchNbr = 0
     C                   Dou       *in90 = *on
     C                   Eval      SearchNbr = SearchNbr + 1
     C                   Eval      Idx = SearchNbr
     C                   Movea     ##Search      Search#(Idx)
     C     Klook2        Reade     @Lookv0                                90
     C                   Enddo
     C                   Else
      *
      *    1 Branch
      *    2 User
      *    3 Payment Type
      *    4 Payment Sub-Type
      *    5 Settlement Method
      *    6 Network
      *    7 Network Message Type
      *    8 Add Deduct Indicator
      *    9 Fx Transaction
      *
      * Set Searches
     C                   Eval      SearchNbr = 4
     C                   Movea     'YNYNNYYNNN'  Search#(1)
     C                   Movea     'YNYYNNNNNN'  Search#(2)
     C                   Movea     'YYNNNNNNNN'  Search#(3)
     C                   Movea     'YNNNNNNNNN'  Search#(4)
     C                   Endif
      *
     C                   Movel     'Y'           #First            1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Get Default Book
      *****************************************************************
     C     GetDefBook    BEGSR
      *
      * Get message details
      *
     C     KBkdf         KLIST
     C                   Kfld                    K_BDBRCA
     C                   Kfld                    K_BDUSER
     C                   Kfld                    K_BDPTYP
     C                   Kfld                    K_BDPYST
     C                   Kfld                    K_BDSTMT
     C                   Kfld                    K_BDNWRK
     C                   Kfld                    K_BDMTPY
     C                   Kfld                    K_BDADDC
     C                   Kfld                    K_BDFXTR
      *
     C                   Do        SearchNbr     Idx
     C                   Clear                   Keys
     C                   Movea     Search#(Idx)  KeySV(1)
     C                   If        KeySV(1) = 'Y'
     C                   Eval      K_BDBRCA = V_BDBRCA
     C                   Endif
     C                   If        KeySV(2) = 'Y'
     C                   Eval      K_BDUSER = V_BDUSER
     C                   Endif
     C                   If        KeySV(3) = 'Y'
     C                   Eval      K_BDPTYP = V_BDPTYP
     C                   Endif
     C                   If        KeySV(4) = 'Y'
     C                   Eval      K_BDPYST = V_BDPYST
     C                   Endif
     C                   If        KeySV(5) = 'Y'
     C                   Eval      K_BDSTMT = V_BDSTMT
     C                   Endif
     C                   If        KeySV(6) = 'Y'
     C                   Eval      K_BDNWRK = V_BDNWRK
     C                   If        K_BDNWRK = *blanks
     C                   Iter
     C                   Endif
     C                   Endif
     C                   If        KeySV(7) = 'Y'
     C                   Eval      K_BDMTPY = V_BDMTPY
     C                   If        K_BDMTPY = *blanks
     C                   Iter
     C                   Endif
     C                   Endif
     C                   If        KeySV(8) = 'Y'
     C                   Eval      K_BDADDC = V_BDADDC
     C                   Endif
     C                   If        KeySV(9) = 'Y'
     C                   Eval      K_BDFXTR = V_BDFXTR
     C                   Endif
      *
     C     KBkdf         Chain     @Bkdfv0
      * If found use as default
     C                   If        %Found
     C                   Eval      OutBook  = BDBOOK
     C                   Leave
     C                   Endif
     C                   Enddo
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2003
