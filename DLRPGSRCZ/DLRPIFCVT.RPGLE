     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Conversion to scrn')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFCVT - DL RPIF Conversion: File to Screen Format        *
      *                                                               *
      *  Function:  This module converts the fields of deal's         *
      *             reporting information from their format as on     *
      *             file to a screen format.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Second data structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Deal in File Format
     D DLRPIFPDDtl   E DS                  EXTNAME(DLRPIFPD)
 
      ** Deal in Screen Format 1
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
 
      ** Deal in Screen Format 2
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
 
      ** Deal in Screen Format 3
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
                                                                                              CSW214
      ** Deal in Screen Format 4                                                              CSW214
     D DLRIS4Detail  E DS                  EXTNAME(DLRIS4PD)                                  CSW214
 
      ** Customer Details Format
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Customer Extension SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
      ** Second data structure for Access Programs, long DS
     D DSLDY         E DS                  Extname(DSLDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WCustN          S              6A
     D WRetCode        S             10A
     D WStr            S              5S 0
     D WLen            S              5S 0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCusn           S             10A
     D PKySt           S              6A
     D CSW214          S              1A                                                      CSW214
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Set output screen fields
      *
     C                   EXSR      SRSetFld
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetFld - Set output screen fields                          *
      *****************************************************************
     C     SRSetFld      BEGSR
      *
      ** 1st screen
      *
     C                   IF        RITRID <> *BLANKS
     C                   EVAL      R1TRID = RITRID
     C                   EVAL      WCustN = RITRID
     C                   EXSR      SRGetCust
     C                   EVAL      R1TRNM = BBCRNM
     C                   EVAL      R1TRTN = BBCRTN
     C                   EVAL      R1TRIS = BBCSID
     C                   ENDIF
 
     C                   EVAL      R1CCPA = RICCPA
 
     C                   IF        RICCPI <> *BLANKS
     C                   EVAL      R1CCPI = RICCPI
     C                   EVAL      WCustN = RICCPI
     C                   EXSR      SRGetCust
     C                   EVAL      R1CCPN = BBCRNM
     C                   EVAL      R1CCPC = BBCRTN
     C                   EVAL      R1CCPS = BBCSID
     C                   EVAL      R1CCPL = CSLEIC
     C                   ENDIF
 
     C                   EVAL      R1CEPA = RICEPA
 
     C                   IF        RICEPI <> *BLANKS
     C                   EVAL      R1CEPI = RICEPI
     C                   EVAL      WCustN = RICEPI
     C                   EXSR      SRGetCust
     C                   EVAL      R1CEPN = BBCRNM
     C                   EVAL      R1CEPC = BBCRTN
     C                   EVAL      R1CEPS = BBCSID
     C                   EVAL      R1CEPL = CSLEIC
     C                   ENDIF
 
     C                   EVAL      R1CBIC = RICBCI
     C                   EVAL      R1CBIH = RICBPI
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R1CBRA = RICBRA                                            CSW214
                                                                                              CSW214
     C                   IF        RICBRI <> *BLANKS                                          CSW214
     C                   EVAL      R1CBRI = RICBRI                                            CSW214
     C                   EVAL      WCustN = RICBRI                                            CSW214
     C                   EXSR      SRGetCust                                                  CSW214
     C                   EVAL      R1CBNM = BBCRNM                                            CSW214
     C                   EVAL      R1CBTN = BBCRTN                                            CSW214
     C                   EVAL      R1CBSW = BBCSID                                            CSW214
     C                   EVAL      R1CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   EVAL      R1CPID = RIPRID
     C                   EVAL      R1EXVE = RIEXVE
     C                   EVAL      R1UPID = RIUPID
     C                   EVAL      R1LSID = RILSID
      *
      ** 2nd screen
      *
     C                   EVAL      R2RPJ1 = RIRJ01
     C                   EVAL      R2RPP1 = RIRP01
     C                   EVAL      R2RPN1 = RIRN01
     C                   EVAL      R2UTI1 = RIUT01
     C                   EVAL      R2TRI1 = RITNI1
     C                   EVAL      R2TRC1 = RIRC01
     C                   EVAL      R2TTY1 = RITIT1
     C                   EVAL      R2EVT1 = RIETT1
     C                   EVAL      R2RPS1 = RIRS01
     C                   EVAL      R2RPL1 = RIRL01
     C                   EVAL      R2RPA1 = RIRA01
     C                   EVAL      R2RPJ2 = RIRJ02
     C                   EVAL      R2RPP2 = RIRP02
     C                   EVAL      R2RPN2 = RIRN02
     C                   EVAL      R2UTI2 = RIUT02
     C                   EVAL      R2TRI2 = RITNI2
     C                   EVAL      R2TRC2 = RIRC02
     C                   EVAL      R2TTY2 = RITIT2
     C                   EVAL      R2EVT2 = RIETT2
     C                   EVAL      R2RPS2 = RIRS02
     C                   EVAL      R2RPL2 = RIRL02
     C                   EVAL      R2RPA2 = RIRA02
     C                   EVAL      R2RPJ3 = RIRJ03
     C                   EVAL      R2RPP3 = RIRP03
     C                   EVAL      R2RPN3 = RIRN03
     C                   EVAL      R2UTI3 = RIUT03
     C                   EVAL      R2TRI3 = RITNI3
     C                   EVAL      R2TRC3 = RIRC03
     C                   EVAL      R2TTY3 = RITIT3
     C                   EVAL      R2EVT3 = RIETT3
     C                   EVAL      R2RPS3 = RIRS03
     C                   EVAL      R2RPL3 = RIRL03
     C                   EVAL      R2RPA3 = RIRA03
     C                   EVAL      R2RPJ4 = RIRJ04
     C                   EVAL      R2RPP4 = RIRP04
     C                   EVAL      R2RPN4 = RIRN04
     C                   EVAL      R2UTI4 = RIUT04
     C                   EVAL      R2TRI4 = RITNI4
     C                   EVAL      R2TRC4 = RIRC04
     C                   EVAL      R2TTY4 = RITIT4
     C                   EVAL      R2EVT4 = RIETT4
     C                   EVAL      R2RPS4 = RIRS04
     C                   EVAL      R2RPL4 = RIRL04
     C                   EVAL      R2RPA4 = RIRA04
      *
      ** 3rd screen
      *
     C                   IF        RIGEDT = 0
     C                   EVAL      R3TSDT = *BLANKS
     C                   ELSE
 
     C                   IF        BJDFIN = 'D'
     C                   EVAL      R3TSDT = %CHAR(%DATE(RIGEDT: *ISO):*DMY0)
     C                   ELSE
     C                   EVAL      R3TSDT = %CHAR(%DATE(RIGEDT: *ISO):*MDY0)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RIGETM = 0
     C                   EVAL      R3TSTM = *BLANKS
     C                   ELSE
     C                   MOVE      RIGETM        R3TSTM
     C                   ENDIF
 
     C                   EVAL      R3UTSS = RIUSGN
 
     C                   IF        RIUTCT = 0
     C                   EVAL      R3UTST = *BLANKS
     C                   ELSE
     C                   MOVE      RIUTCT        R3UTST
     C                   ENDIF
 
     C                   EVAL      R3CTIN = RICGTI
     C                   EVAL      R3ALIN = RIALLI
     C                   EVAL      R3COIN = RICLLI
     C                   EVAL      R3NSFG = RINORS
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R3FNCI = RIFNCI                                            CSW214
     C                   EVAL      R3COPI = RICOPI                                            CSW214
     C                   EVAL      R3COPC = RICOPC                                            CSW214
     C                   EVAL      R3POCI = RIPOCI                                            CSW214
     C                   EVAL      R3COSI = RICOSI                                            CSW214
     C                   EVAL      R3TNEI = RITNEI                                            CSW214
     C                   EVAL      R3IGTI = RIIGTI                                            CSW214
     C                   EVAL      R3CTFI = RICTFI                                            CSW214
     C                   ENDIF                                                                CSW214
     C**********         EVAL      R3AR01 = RIAR01                                            CSW214
     C**********         EVAL      R3AR02 = RIAR02                                            CSW214
     C**********         EVAL      R3AR03 = RIAR03                                            CSW214
     C**********         EVAL      R3AR04 = RIAR04                                            CSW214
     C**********         EVAL      R3AR05 = RIAR05                                            CSW214
     C**********         EVAL      R3AR06 = RIAR06                                            CSW214
     C**********         EVAL      R3AR07 = RIAR07                                            CSW214
     C**********         EVAL      R3AR08 = RIAR08                                            CSW214
     C**********         EVAL      R3AR09 = RIAR09                                            CSW214
     C**********         EVAL      R3AR10 = RIAR10                                            CSW214
     C**********         EVAL      R3AR11 = RIAR11                                            CSW214
     C**********         EVAL      R3AR12 = RIAR12                                            CSW214
     C**********         EVAL      R3AR13 = RIAR13                                            CSW214
     C**********         EVAL      R3AR14 = RIAR14                                            CSW214
     C**********         EVAL      R3AR15 = RIAR15                                            CSW214
     C**********         EVAL      R3AR16 = RIAR16                                            CSW214
     C**********         EVAL      R3AR17 = RIAR17                                            CSW214
     C**********         EVAL      R3AR18 = RIAR18                                            CSW214
     C**********         EVAL      R3AR19 = RIAR19                                            CSW214
     C**********         EVAL      R3AR20 = RIAR20                                            CSW214
     C                   EVAL      R3TMST = RITMST
                                                                                              CSW214
      ** 4th screen                                                                           CSW214
                                                                                              CSW214
     C                   EVAL      R4AR01 = RIAR01                                            CSW214
     C                   EVAL      R4AR02 = RIAR02                                            CSW214
     C                   EVAL      R4AR03 = RIAR03                                            CSW214
     C                   EVAL      R4AR04 = RIAR04                                            CSW214
     C                   EVAL      R4AR05 = RIAR05                                            CSW214
     C                   EVAL      R4AR06 = RIAR06                                            CSW214
     C                   EVAL      R4AR07 = RIAR07                                            CSW214
     C                   EVAL      R4AR08 = RIAR08                                            CSW214
     C                   EVAL      R4AR09 = RIAR09                                            CSW214
     C                   EVAL      R4AR10 = RIAR10                                            CSW214
     C                   EVAL      R4AR11 = RIAR11                                            CSW214
     C                   EVAL      R4AR12 = RIAR12                                            CSW214
     C                   EVAL      R4AR13 = RIAR13                                            CSW214
     C                   EVAL      R4AR14 = RIAR14                                            CSW214
     C                   EVAL      R4AR15 = RIAR15                                            CSW214
     C                   EVAL      R4AR16 = RIAR16                                            CSW214
     C                   EVAL      R4AR17 = RIAR17                                            CSW214
     C                   EVAL      R4AR18 = RIAR18                                            CSW214
     C                   EVAL      R4AR19 = RIAR19                                            CSW214
     C                   EVAL      R4AR20 = RIAR20                                            CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGetCust - Get Customer Details                             *
      *****************************************************************
     C     SRGetCust     BEGSR
      *
     C                   CLEAR                   DSLDY
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
      *
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %LEN(SDCUST) + 1
     C                   EVAL      WLen = %LEN(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %SUBST(DSLDY:WStr:WLen)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      * Return Code
     C                   PARM                    WRetCode
      *
      ** Deal in file format
     C                   PARM                    DLRPIFPDDtl
      *
      ** Output parameters
      *
      ** Transaction Reporting screen 1
     C                   PARM                    DLRIS1Detail
      *
      ** Transaction Reporting screen 2
     C                   PARM                    DLRIS2Detail
      *
      ** Transaction Reporting screen 3
     C                   PARM                    DLRIS3Detail
                                                                                              CSW214
      ** Transaction Reporting screen 4                                                       CSW214
                                                                                              CSW214
     C                   PARM                    DLRIS4Detail                                 CSW214
      *
      ** Initialize program name
      *
     C                   MOVEL     'DLRPIFCVT'   DBPGM
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                              CSW214
      ** Check if SWIFT 2014 feature is installed                                             CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PrtCd                                        CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   IF        PrtCd   = 'CSW2014'                                        CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ENDIF                                                                CSW214
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
