     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment input - Read')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYRED - Manual Repayment - Read                          *
      *                                                               *
      *  Function:  This module reads forwards and backwards stomer   *
      *             through the Manual Repayment file (LOAMSDK)       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEMAPYL0  IF   E           K DISK    INFSR(*PSSR)
      *** Live LOANS by Front Office Id.
     F                                     RENAME(LOAMSDKF:MAPYL0)
 
     FLEMAPYL1  IF   E           K DISK    INFSR(*PSSR)
      *** Live LOANS awaiting authorization by Front Office Id.
     F                                     RENAME(LOAMSDKF:MAPYL1)
 
     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
      *** Live LOANS by Loan Reference / Value date / Sequence
     F                                     RENAME(LOAMSDKF:LOAML0)
 
     FLELOAML1  IF   E           K DISK    INFSR(*PSSR)
      *** Live LOANS awaiting authorization by Loan Reference / Value date / Sequence
     F                                     RENAME(LOAMSDKF:LOAML1)
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ***  Initialize outputs
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @ERRDTA                                      CLE148
     C                   MOVEL     *BLANK        @LNRED                         Loan number
     C                   MOVEL     *BLANK        @VDRED                         Value Date
     C                   MOVEL     *BLANK        @SQRED                           Seq.
     C                   MOVEL     *BLANK        @FTRED
      *
      ***  Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Manual Repayment (for pointer)
      *
     C                   EXSR      VALMAPY
      *
      ***  Read forwards
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      ***  Read backwards
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
 
      ***  Return
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through repayments schedule file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      ***  Position to current record on file
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
      ***  By Front Office Id.
      *
     C     DDACTN        IFEQ      'X'
     C     K@FRNT        SETGT     MAPYL1                                       Loans For Auth
     C                   ELSE
     C     K@FRNT        SETGT     MAPYL0
     C                   ENDIF
 
     C                   ELSE
      *
      ***  by loans Ref. / Value Date / Sequence
      *
     C     DDACTN        IFEQ      'X'
     C     K@LOAM        SETGT     LOAML1                                       Loans For Auth
     C                   ELSE
     C     K@LOAM        SETGT     LOAML0
     C                   ENDIF
     C                   ENDIF
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'                                          EOF
     C     ASTS          ORNE      'D'                                          not deleted
     C     AMTP          ANDEQ     'MR'                                         Manual Repay
     C     @@ERR         ANDEQ     *ZERO                                        no error
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
      ***  using Front Office Id.
      *
     C     DDACTN        IFEQ      'X'
     C                   READ      MAPYL1                                 99
     C                   ELSE
     C                   READ      MAPYL0                                 99
     C                   ENDIF
 
     C                   ELSE
      *
      ***  or using Loan Ref. / Value Date / Sequence
      *
     C     DDACTN        IFEQ      'X'
     C                   READ      LOAML1                                 99
     C                   ELSE
     C                   READ      LOAML0                                 99
     C                   ENDIF
 
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA                           Loan Branch
     C                   PARM                    @@ERR                          user auth. on it
     C                   ENDIF
      *
     C                   ENDDO                                                  user Auth. or EOF
      *
      ***  If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDLNRF        IFEQ      *BLANKS
     C     FOTRID        ANDEQ     *BLANKS
      *
      ***  'No valid record exists on file'
      *
     C                   MOVEL     'LEV9000'     @ERRMS
     C                   ELSE
      *
      ***  'No more Record on file, F8 cannot be used anymore'
      *
     C                   MOVEL     'LEV9001'     @ERRMS
     C                   END
 
     C                   ELSE
      *
      ***  Valid Loan ==>  return the Manual Repayment read details
      *
     C                   MOVE      LNRF          @LNRED
     C                   MOVE      LASN          @SQRED
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     @VDRED
      *
     C                   MOVE      FRNT          @FTRED
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through repayments schedule file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      ***  Position to current record on file
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
      ***  By Front Office Id.
      *
     C     DDACTN        IFEQ      'X'
     C     K@FRNT        SETLL     MAPYL1                                       Loans for Auth.
     C                   ELSE
     C     K@FRNT        SETLL     MAPYL0
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  By Loans Ref. / Value Date / Sequence
      *
     C     DDACTN        IFEQ      'X'
     C     K@LOAM        SETLL     LOAML1                                       Loans For Auth.
     C                   ELSE
     C     K@LOAM        SETLL     LOAML0
     C                   END
     C                   END
 
      ***  Read until end of file or a valid record is found
      *
     C     *IN99         DOUEQ     '1'                                          BOF
     C     ASTS          ORNE      'D'                                          not deleted
     C     AMTP          ANDEQ     'MR'                                         Manual Repayment
     C     @@ERR         ANDEQ     *ZERO                                        user Auth. on it
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
      ***  using Front Office Id.
      *
     C     DDACTN        IFEQ      'X'
     C                   READP     MAPYL1                                 99
     C                   ELSE
     C                   READP     MAPYL0                                 99
     C                   ENDIF
 
     C                   ELSE
      *
      ***  Else Loan Ref. / Value Date / sequence
      *
     C     DDACTN        IFEQ      'X'
     C                   READP     LOAML1                                 99
     C                   ELSE
     C                   READP     LOAML0                                 99
     C                   ENDIF
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDDO                                                  Loan valid or BOF
      *
      ***  If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
      *
      ***  'First Record encountered, F7 no more available.'
      *
     C                   MOVEL     'LEV9002'     @ERRMS
      *
     C                   ELSE
      *
      ***  Valid Loans,  return the Manual Repayment read details
      *
     C                   MOVE      LNRF          @LNRED
     C                   MOVE      LASN          @SQRED
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     @VDRED
      *
     C                   MOVE      FRNT          @FTRED
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ***  Return error message
      *
     C     @@ERR         IFEQ      1
      *
      ***  'Action code is not valid for user'
      *
     C                   MOVEL     'LEV9003'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALMAPY- Validate repayments schedule pointer
      *****************************************************************
     C     VALMAPY       BEGSR
      *
     C                   MOVE      FOTRID        K@FRNT           20
      *
      ***  Validate that the loan number is numeric or blank.
      *
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*****DDLNRF        IFEQ      *BLANKS                                                    CLE148
     C******IN98         OREQ      '1'                                                        CLE148
     C******IN99         ANDEQ     '1'                                                        CLE148
     C**********         MOVE      DDLNRF        K@LNRF                                       CLE148
      *
      *****Return*error*message****************************************                       CLE148
      *
     C**********         ELSE                                                                 CLE148
      *
      *****'Loan*Ref.*Must*be*numeric*or*left*blank'*******************                       CLE148
      *
     C**********         MOVEL     'LES0608'     @ERRMS                                       CLE148
     C**********         RETURN                                                               CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        DDLNRF = *BLANKS                                           CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        K@LNRF                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   RETURN                                                               CLE148
     C                   ENDIF                                                                CLE148
      *
      ***  Validate that the sequence is numeric or blank.
      *
     C                   TESTN                   DDSEQN               98
     C                   MOVE      DDSEQN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDSEQN        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDSEQN        K@SEQN
      *
      ***  Return error message
      *
     C                   ELSE
      *
      ***  'Sequence Must be numeric or left blank'
      *
     C                   MOVEL     'LES0609'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      ***  Validate that the value date is valid or blank.
      *
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFEQ      *BLANKS
     C     DDVDAT        OREQ      *BLANKS
     C                   MOVE      ZDAYNO        K@VDAT
      *
      ***  Return error message
      *
     C                   ELSE
      *
      ***  'Value Date Must be numeric and in valid format'
      *
     C                   MOVEL     'LES0610'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
     C                   PARM                    RetCodeIn                      Ret Code
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
     C                   PARM                    DDACTN            1            Action code
     C                   PARM                    DDLNRF            6            Deal number pointer
     C                   PARM                    DDVDAT            6            Value date pointer
     C                   PARM                    DDSEQN            3            Sequence pointer
     C                   PARM                    FOTRID           20            Front Office Transac
     C                   PARM                    @RDFWD            1            Read forwards
     C                   PARM                    @RDBCK            1            Read backwards
      *
      ***  Output parameters
      *
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7            Error message
     C                   PARM                    @ERRDTA                                      CLE148
     C                   PARM                    @LNRED            6            Loan number
     C                   PARM                    @VDRED            6            Value date
     C                   PARM                    @SQRED            3            Sequence
     C                   PARM                    @FTRED           20            Front Office Loan
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEMAPYRED'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      *** KLIST for LOAMSDK access
      *
     C     K@LOAM        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@VDAT            5 0
     C                   KFLD                    K@SEQN            3 0
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
