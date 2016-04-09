     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP receivers charges remitted')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIRCRM - Validate IP Receiver's Charges Remitted           *
      *                                                               *
      *  Function:  This module validates Receiver's Charges Remitted.*
      *             This is a component of FTIPAYCTL, FTIPAYRPR,      *
      *             FTIPAYSIN, and service program for level 2        *
      *             validation modules.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 200949             Date 05Oct06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 208219             Date 27Apr06               *
      *                 220327             Date 25Aug03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209868             Date 08Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  200949 - Suppress FTM5031.  Applied core fix 197943.         *
      *           Same fix as 208219.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  208219 - Suppress FTM5031.                                   *
      *  220327 - Receiver's Charges Remitted not saved during IP     *
      *  209868 - Do not default Receivers Charges if Instructed      *
      *           Amount Currency in first screen was blanks.         *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
 
      ** Incoming Payments Lvl 1 details
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
 
      ** Incoming Payments Lvl 2 Scrn 3 details
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)
 
      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     D OKIPY4DS      E DS                  EXTNAME(FTEIPY4PD)
 
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *                                                                                       CFT120
      ** DS for Access Objects - short data structure                                         CFT120
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFT120
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error messages
     D Idx             S              3P 0
 
      ** Index for arrays of warning messages
     D WIdx            S              3P 0
     D CFT120          S              1A                                                      CFT120
 
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
 
      **
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      **                                                                                    MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
     C                   EVAL      WRCRM = 0                                                  220327
 
     C                   EXSR      SRRCRM
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y' OR WarnFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF
 
      ** Otherwise, set up file field                                                         220327
                                                                                              220327
     C                   IF        OKRCRM <> 'N'                                              220327
     C                   EVAL      I2INRCRM = WRCRM                                           220327
     C                   ENDIF                                                                220327
                                                                                              220327
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCRM - Validation of Receiver's Charges Remitted.          *
      *                                                               *
      *****************************************************************
     C     SRRCRM        BEGSR
      *
      ** Check details of settle currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDSMCY        PInChr03          3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RTCD <> *BLANKS
     C                   Z-ADD     3             DBASE
     C                   MOVEL     DDSMCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *
      ** Bypass validation if Receiver's Charges Remitted is blank
      ** and details of charge is not 'OUR'.
 
     C                   IF        (DDRCRM = *BLANKS)
     C                   IF        (DDDTCH <> 'OUR')
     C                   GOTO      EXRCRM
     C                   ELSE
      ** Only default if Instructed Amount Currency on First Screen was entered               209868
     C                   If        DDNDCY <> *BLANKS                                          209868
     C                   EVAL      I2INRCRM = 0
     C                   MOVE      *BLANK        PInOutChr16
     C                   MOVE      *ZEROS        PInOutChr16
     C                   CALLB     'ZEDIT'
     C                   PARM                    PInOutChr16
     C                   PARM      A6NBDP        PInNum010
     C                   MOVE      PInOutChr16   DDRCRM
     C                   EndIf                                                                209868
     C                   ENDIF
     C                   ENDIF
 
      *
      ** May only be entered if Details of Charges is 'OUR'
 
     C                   IF        (DDDTCH <> 'OUR')
     C                             AND (DDRCRM <> *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5032'
     C                   EVAL      FldNamXAr(Idx) = 'DDRCRM'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRCRM = 'N'
     C                   GOTO      EXRCRM
     C                   ENDIF
 
      *
      ** Entry must be a valid amount in Settlement currency
 
     C                   EVAL      WRCRM = 0
     C                   EVAL      PICHR16 = DDRCRM
     C                   EVAL      PDIG = 11 - A6NBDP
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    PICHR16          16
     C                   PARM      A6NBDP        PDEC              1 0
     C                   PARM                    PDIG              2 0
     C                   PARM      *BLANKS       POutChr16        16
     C                   IF        (@RTCD <> *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5033'
     C                   EVAL      FldNamXAr(Idx) = 'DDRCRM'
     C*****DDRCRM        CAT       DDSMCY        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDRCRM))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDRCRM)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSMCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(DDSMCY)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRCRM = 'N'
     C                   GOTO      EXRCRM
     C                   ELSE
     C                   MOVE      POutChr16     WRCRM            11 0
     C                   MOVE      *BLANKS       PInOutChr16
     C                   MOVE      POutChr16     PInOutChr16
     C                   CALLB     'ZEDIT'
     C                   PARM                    PInOutChr16      16
     C                   PARM      A6NBDP        PInNum010         1 0
     C                   If        (DDNDCY <> *BLANKS)                                        209868
     C                   MOVE      PInOutChr16   DDRCRM
     C                   EndIf                                                                209868
     C                   ENDIF
 
      *
      ** Send warning message if Receiver's Charges is not equal to total
      ** charges calculated
 
     C                   EVAL      WTOTCHG = 0
 
     C                   SELECT
 
      *
      ** Entry charge currency = Settle currency
     C                   WHEN      (PENTCHGCCY = DDSMCY)
      ** Transfer commission
     C                   Z-ADD     IPDUMA1       WTOTCHG          15 0
      ** Telex charge
     C                   ADD       IPDUMA2       WTOTCHG
      ** Cheque charge
     C                   ADD       IPDUMA3       WTOTCHG
      ** Advice charge
     C                   ADD       IPDUMA4       WTOTCHG
      ** Telephone charge
     C                   ADD       IPDUMA5       WTOTCHG
      ** Miscellaneous charge
     C                   ADD       IPDUMA6       WTOTCHG
      ** FX/Change commission
     C                   IF        (S01494 = 'Y')
     C                   ADD       IPINDUM7      WTOTCHG
     C                   ENDIF
      ** VAT
     C                   IF        (S01499 = 'Y')
     C                   ADD       IPINDUM8      WTOTCHG
     C                   ENDIF
 
      *
      ** File charge currency = Settle currency
     C                   WHEN      (PFILCHGCCY = DDSMCY)
      ** Transfer commission
     C                   Z-ADD     IPTRCM        WTOTCHG
      ** Telex charge
     C                   ADD       IPTXCH        WTOTCHG
      ** Cheque charge
     C                   ADD       IPCQCH        WTOTCHG
      ** Advice charge
     C                   ADD       IPADCH        WTOTCHG
      ** Telephone charge
     C                   ADD       IPTLCH        WTOTCHG
      ** Miscellaneous charge
     C                   ADD       IPMSCH        WTOTCHG
      ** FX/Change commission
     C                   IF        (S01494 = 'Y')
     C                   ADD       IPINCHCM      WTOTCHG
     C                   ENDIF
      ** VAT
     C                   IF        (S01499 = 'Y')
     C                   ADD       IPINVATT      WTOTCHG
     C                   ENDIF
 
      *
      ** Catchall
     C                   OTHER
      ** Transfer commission
     C                   Z-ADD     IPDUMA1       WTOTCHG
      ** Telex charge
     C                   ADD       IPDUMA2       WTOTCHG
      ** Cheque charge
     C                   ADD       IPDUMA3       WTOTCHG
      ** Advice charge
     C                   ADD       IPDUMA4       WTOTCHG
      ** Telephone charge
     C                   ADD       IPDUMA5       WTOTCHG
      ** Miscellaneous charge
     C                   ADD       IPDUMA6       WTOTCHG
      ** FX/Change commission
     C                   IF        (S01494 = 'Y')
     C                   ADD       IPINDUM7      WTOTCHG
     C                   ENDIF
      ** VAT
     C                   IF        (S01499 = 'Y')
     C                   ADD       IPINDUM8      WTOTCHG
     C                   ENDIF
 
      ** Convert total charge calculated if neither Input Charge ccy
      ** nor File Charge ccy is equal to Settle ccy
     C                   CLEAR                   P#0010
     C                   Z-ADD     *ZEROS        P#NDAM
     C                   Z-ADD     *ZEROS        P#PDAM
     C                   Z-ADD     *ZEROS        P#FRDT
     C                   Z-ADD     *ZEROS        P#TODT
     C                   Z-ADD     *ZEROS        P#RATE
     C                   Z-ADD     *ZEROS        P#MDIN
     C                   Z-ADD     *ZEROS        P#RTDS
     C                   MOVE      *Blanks       P#INDC
     C                   MOVE      *Blanks       P#RTCD
     C                   Movel     'FTVIRCRM'    P#PMSQ
     C                   EVAL      P#FRCY = PENTCHGCCY
     C                   EVAL      P#FRAM = WTOTCHG
     C                   EVAL      P#TOAM = 0
     C                   EVAL      P#TOCY = DDSMCY
     C                   IF        (P#FRAM <> 0 AND CFT120 = 'Y')                             CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
     C                   EXSR      SRFT0010
     C                   ENDIF                                                                CFT120
     C                   EVAL      WTOTCHG = P#TOAM
 
     C                   ENDSL
 
     C                   IF        (WRCRM <> WTOTCHG)
     C                   IF        (DDRCRM <> PPrvDDRCRM)
     C                             OR (WTOTCHG <> PPrvTOTCHG)
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WMsgIdXAr (WIdx) = 'FTM5041'
     C                   EVAL      WFldNmXAr(WIdx) = 'DDRCRM'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      OKRCRM = 'W'
     C                   EVAL      PPrvDDRCRM = DDRCRM
     C                   EVAL      PPrvTOTCHG = WTOTCHG
     C                   EVAL      PFrcReDisplay = 'Y'
     C                   GOTO      EXRCRM
     C                   ENDIF
     C                   ENDIF
 
      *
      ***If*Instructed*amount/currency*from*Level*1*were*not*entered,                         208219
      ******Sender's*charges*should*not*be*entered.                                           208219
      **********                                                                              208219
     C**********         IF        DDNDCY = *BLANKS                                           208219
     C**********                   and (DDRCRM <> *BLANKS)                              209868208219
     C**********         EVAL      Idx = Idx + 1                                              208219
     C**********         EVAL      MsgIdXAr = 'FTM5031'                                       208219
     C**********         EVAL      FldNamXAr(Idx) = 'DDRCRM'                                  208219
     C**********         EVAL      ErrorFound = 'Y'                                           208219
     C**********         EVAL      OKRCRM = 'N'                                               208219
     C**********         GOTOF     EXRCRM                                                     208219
     C**********         ENDIF                                                                208219
 
     C     EXRCRM        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFT0010 - Calculates Currency Amount for EMU.               *
      *                                                               *
      *****************************************************************
     C     SRFT0010      BEGSR
 
     C                   CALL      'FT0010'
     C                   PARM                    P#0010
 
     C                   IF        (P#RTCD <> *BLANKS)
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*CALL  '
     C                   EVAL      DBFILE = 'FT0010 '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** O: Return Code
     C                   PARM                    ReturnCode
      *
      ***********
      ** INPUT **
      ***********
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      ** Incoming Payments Lvl 1 details
     C                   PARM                    NwIP1ScnFmt
      ** Incoming Payments Lvl 2 Scrn 3details
     C                   PARM                    NwIP5ScnFmt
      ** Left-hand side charge currency
     C                   PARM                    PENTCHGCCY        3
      ** Right-hand side charge currency
     C                   PARM                    PFILCHGCCY        3
      ** BLI Funds Transfer enhancement
     C                   PARM                    S01494            1
      ** FT VAT processing
     C                   PARM                    S01499            1
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    OKIPY4DS
      ** I/O: Previous Receiver's charges remitted input
      **      Its value is already maintained inside this module
     C                   PARM                    PPrvDDRCRM       12
      ** I/O: Previous Total charges calculated
      **      Its value is already maintained inside this module
     C                   PARM                    PPrvTOTCHG       15 0
      ** Force redisplay
     C                   PARM                    PFrcReDisplay     1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     4             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
