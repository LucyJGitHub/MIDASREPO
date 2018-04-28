     H DEBUG
     H COPYRIGHT ('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL BITP Retrieve - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITP2RV - GL BITP Retrieve - Extension                     *
      *                                                               *
      *  Function:  This function retrieves the data from the batch   *
      *             item extension file.                              *
      *                                                               *
      *  Component of: SP8GL0004 Service Program                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      ** Journal Entry Post. Extended Index File
     FGLJPX1L0  IF   E           K DISK    PREFIX(JY:2)
     F                                     RENAME(GLJENPDL:GLJINPUT)
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
      *
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
      *
      ** Output Parameter Data Structure
      *
     D BITPExFilFmt  E DS                  EXTNAME(GLJPX1PD)
      *
      ** Standard Entry Parameters
      *
     D PRetCodeIn      S             10
     D PActn           S              1
     D PFrontID        S             20
     D PBatchNo        S              3
     D PBatchItm       S              3
      *
      ** Define Key Fields
      *
     D KBatchNo        S                   LIKE(JEBTNB)
     D KBatchItm       S                   LIKE(JEBINB)
      *
      ** Data Structure
      *
     D DBatchItmNo     DS             3
     D  DBatchItm              1      3S 0
 
      *****************************************************************
      *                 M A I N    P R O C E S S I N G                *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Initialize
      *
     C                   EXSR      SRInit
 
     C                   EVAL      DBatchItmNo = PBatchItm
      *
      ** Access Batch Item Extension File
      *
     C                   EVAL      KBatchNo = PBatchNo
     C                   EVAL      KBatchItm = DBatchItm
     C     KYJENPYL      CHAIN     GLJINPUT                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      JEBTNB = JYBTNB
     C                   EVAL      JEBINB = JYBINB
     C                   EVAL      JEOPC1 = JYOPC1
     C                   EVAL      JECOC1 = JYCOC1
     C                   EVAL      JEIDC1 = JYIDC1
     C                   EVAL      JEIDE1 = JYIDE1
     C                   EVAL      JEOPC2 = JYOPC2
     C                   EVAL      JECOC2 = JYCOC2
     C                   EVAL      JEIDC2 = JYIDC2
     C                   EVAL      JEIDE2 = JYIDE2
     C                   EVAL      JEOPC3 = JYOPC3
     C                   EVAL      JECOC3 = JYCOC3
     C                   EVAL      JEIDC3 = JYIDC3
     C                   EVAL      JEIDE3 = JYIDE3
     C                   EVAL      JEPTA1 = JYPTA1
     C                   EVAL      JEDCI1 = JYDCI1
     C                   EVAL      JEPTA2 = JYPTA2
     C                   EVAL      JEDCI2 = JYDCI2
     C                   EVAL      JEPTA3 = JYPTA3
     C                   EVAL      JEDCI3 = JYDCI3
     C                   ENDIF
      *
      ** Exit from program
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      * SRInit - Program Initialization SubRoutine                    *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Initialize Output DS
      *
     C                   CLEAR                   BITPExFilFmt
      *
      ** Numeric fields within BITPExFilFmt have to be reset explicitly
      ** as there are long alpha fileds overlapping these which cause
      ** the CLEAR to put blanks in the numeric fields.
      *
     C                   EVAL      JEBINB = *ZEROS
     C                   EVAL      JEOPC1 = *ZEROS
     C                   EVAL      JEOPC2 = *ZEROS
     C                   EVAL      JEOPC3 = *ZEROS
     C                   EVAL      JEPTA1 = *ZEROS
     C                   EVAL      JEPTA2 = *ZEROS
     C                   EVAL      JEPTA3 = *ZEROS
      *
      ** Initialize DS
      *
     C                   CLEAR                   DBatchItmNo
     C                   EVAL      DBatchItm = *ZEROS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialization SubRoutine                    *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PActn
     C                   PARM                    PFrontID
     C                   PARM                    PBatchNo
     C                   PARM                    PBatchItm
     C                   PARM                    BITPExFilFmt
      *
      ** Key Fields
      *
     C     KYJENPYL      KLIST
     C                   KFLD                    KBatchNo
     C                   KFLD                    KBatchItm
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
