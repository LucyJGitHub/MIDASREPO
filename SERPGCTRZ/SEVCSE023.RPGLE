     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Withholding Tax fields.')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVCSE023 - Validate Withholding Tax fields .                *
      *                                                               *
      *  Component of: SESECSCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 05Jun06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGP001             Date 18Dec03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE026 - Consumer Banking                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGP001 - Global Processing (Recompile)                       *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDEXEML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDEXEMD0:@EXEML1)
     FSDINCCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINCCD0:@INCCL1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** External DS for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  NotNumeric            01     01
     D  RecNotFnd             80     80
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IdX             S              3P 0
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PCTRY           S              2A
     D PPROT           S              1A
 
     D KCRTT           S              2A
     D KINCT           S              2A
     D KEXEM           S              2A
 
     D OKCRTT          S              1A   INZ(*BLANKS)
     D OKINCT          S              1A   INZ(*BLANKS)
     D OKEXEM          S              1A   INZ(*BLANKS)
     D OKOIDI          S              1A   INZ(*BLANKS)
     D OKAPIE          S              1A   INZ(*BLANKS)
 
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IdX = 0
      *
      ** Validate withholding tax fields.
      *
     C                   EXSR      SRValWTax
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        IdX <> 0
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        IdX = 0
     C                   EVAL      S1CRTT = DDCRTT
     C                   EVAL      S1INCT = DDINCT
     C                   EVAL      S1EXCD = DDEXCD
     C                   EVAL      S1OIDI = DDOIDI
     C                   EVAL      S1APIE = DDAPIE
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALWTAX - Validation for Wihholding Tax fields             *
      *                                                               *
      *****************************************************************
     C     SRValWTAX     BEGSR
 
      ** Validate Country of tax treaty (DDCRTT)
 
     C     DDCRTT        IFNE      *BLANKS
 
      ** Question mark is valid only on repair and i/c screens input.
 
     C     '?'           SCAN      DDCRTT                                 01
 
     C                   IF        NotNumeric = *On
     C                   EVAL      PRtcd = '*ERROR '
     C                   ELSE
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCRTT        PCTRY
     C     SDCTRY        PARM      SDCTRY        DSSDY
     C                   ENDIF
 
     C     PRtcd         IFNE      *BLANKS
     C                   MOVE      'N'           OKCRTT
     C                   ADD       1             IdX
     C                   MOVEL     'DDCRTT'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0101'     MsgIdXAr(IdX)
     C                   ELSE
     C                   MOVE      A4CNCD        DDCRTT
     C                   MOVE      DDCRTT        KCRTT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Income Type (DDINCT)
 
     C     OKCRTT        IFNE      'N'
 
     C     DDCRTT        IFNE      *BLANKS
     C     DDINCT        ANDEQ     *BLANKS
     C                   MOVE      'N'           OKINCT
     C                   ADD       1             IdX
     C                   MOVEL     'DDINCT'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0102'     MsgIdXAr(IdX)
 
     C                   ELSE
 
     C     DDINCT        IFNE      *BLANKS
     C                   MOVE      DDINCT        KINCT
     C     KEY1          CHAIN     @INCCL1                            80
 
     C     RecNotFnd     IFEQ      *ON
     C                   MOVE      'N'           OKINCT
     C                   ADD       1             IdX
     C                   MOVEL     'DDINCT'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0103'     MsgIdXAr(IdX)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Exemption Code (DDEXCD)
 
     C     DDEXCD        IFNE      *BLANKS
     C     OKCRTT        ANDNE     'N'
     C                   MOVE      DDEXCD        KEXEM
     C     KEY2          CHAIN     @EXEML1                            80
 
     C     RecNotFnd     IFEQ      *ON
     C                   MOVE      'N'           OKEXEM
     C                   ADD       1             IdX
     C                   MOVEL     'DDEXCD'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0104'     MsgIdXAr(IdX)
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Processing type is not 2, not 4 and not 7
 
     C                   IF        PPROT <> '2' AND PPROT <> '4' AND
     C                             PPROT <> '7'
 
      ** Validate Original Interest Discount (DDOID)
 
     C     DDOIDI        IFNE      'Y'
     C     DDOIDI        ANDNE     'N'
     C     DDOIDI        ANDNE     *BLANKS
     C                   MOVE      'N'           OKOIDI
     C                   ADD       1             IdX
     C                   MOVEL     'DDOIDI'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0105'     MsgIdXAr(IdX)
     C                   ELSE
 
     C     DDOIDI        IFEQ      *BLANKS
     C                   MOVE      'N'           DDOIDI
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Portfolio Interest Exemption (DDPOIE)
 
     C     DDAPIE        IFNE      'Y'
     C     DDAPIE        ANDNE     'N'
     C     DDAPIE        ANDNE     *BLANKS
     C                   MOVE      'N'           OKAPIE
     C                   ADD       1             IdX
     C                   MOVEL     'DDAPIE'      FldNamXAr(IdX)
     C                   MOVEL     'WNE0106'     MsgIdXAr(IdX)
 
     C                   ELSE
 
     C     DDAPIE        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDAPIE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
 
      ** Set up KLIST
 
     C     KEY1          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KINCT
 
     C     KEY2          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KEXEM
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
