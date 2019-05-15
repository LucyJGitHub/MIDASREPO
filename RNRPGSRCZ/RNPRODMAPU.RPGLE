     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RN Product Mappings US Specific')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNPRODMAPU - Product Mappings US specific                    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9794            Date 18Jan06               *
      *                 CRN001  *CREATE    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9794 - Comparion checks should be reversed. LT, LE, GT    *
      *            and GT comparisons return opposite results.        *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FQSYSPRT   O    F  132        PRINTER INFSR(*PSSR) USROPN
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D #_OVRF          S              1    DIM(80) CTDATA PERRCD(80)
     D #_OPNQ          S              1    DIM(160) CTDATA PERRCD(80)
     D #_CLOF          S              1    DIM(80) CTDATA PERRCD(80)
 
      * MAPPING PATH ARRAYS
     D #_GLPATH        S              5S 0 DIM(32767)
     D #_DLPATH        S              5S 0 DIM(32767)
     D #_LEPATH        S              5S 0 DIM(32767)
     D #_SEPATH        S              5S 0 DIM(32767)
 
      * MAPPING ARRAY
     D #_MAPPING       S            154    DIM(32767)
 
     D MAPPING         DS
     D  Product                1     10  0
     D  #_CLAUSE              11    154    DIM(6)
 
     D CLAUSE          DS
     D  Variable               1      2
     D  Test                   3      4
     D  Value                  5     24
 
      * FIELDS ARRAY
     D #_FLDS          S             25    DIM(16)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  PSDS          SDS
     D PROC_NAME         *PROC                                                  * Procedure name
     D PGM_STATUS        *STATUS                                                * Status code
     D PRV_STATUS             16     20S 0                                      * Previous status
     D LINE_NUM               21     28                                         * Src list line num
     D ROUTINE           *ROUTINE                                               * Routine name
     D PARMS             *PARMS                                                 * Num passed parms
     D EXCP_TYPE              40     42                                         * Exception type
     D EXCP_NUM               43     46                                         * Exception number
     D PGM_LIB                81     90                                         * Program library
     D EXCP_DATA              91    170                                         * Exception data
     D EXCP_ID               171    174                                         * Exception Id
     D PROC_PGM              334    343                                         * Pgm Proc is in
     D PROC_MOD              344    353                                         * Mod Proc is in
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      * Clear outputs
 
     C                   Z-ADD     -1            O#Product
     C                   Z-ADD     0             O#CntOfClauses
 
     C                   MOVEL     'N'           MatchFound        1
 
      * Determine product if Dealing input
 
     C     I#DealType    IFNE      *BLANK
     C     I#DealSubType ORNE      *BLANK
     C                   MOVEL     'DL'          ModuleInput       2
     C                   EXSR      DET_PRODUCT
     C     O#Product     CABNE     -1            ENDOFSEARCH
     C                   ENDIF
 
      * Determine product if Lending input
 
     C     I#LoanType    IFNE      *BLANK
     C     I#LoanSubType ORNE      *BLANK
     C     I#FacilityTypeORNE      *BLANK
     C                   MOVEL     'LE'          ModuleInput
     C                   EXSR      DET_PRODUCT
     C     O#Product     CABNE     -1            ENDOFSEARCH
     C                   ENDIF
 
      * Determine product if Securities input
 
     C     I#SecuritySNamIFNE      *BLANK
     C     I#InvestType  ORNE      *BLANK
     C                   MOVEL     'SE'          ModuleInput
     C                   EXSR      DET_PRODUCT
     C     O#Product     CABNE     -1            ENDOFSEARCH
     C                   ENDIF
 
      * Determine product if General Ledger input
 
     C     I#AccountCode IFNE      *BLANK
     C     I#CollateralTyORNE      *BLANK
     C                   MOVEL     'GL'          ModuleInput
     C                   EXSR      DET_PRODUCT
     C                   ENDIF
 
      * Return
 
     C     ENDOFSEARCH   TAG
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * DETERMINE PRODUCT
      ********************************************************************
     C     DET_PRODUCT   BEGSR
     C                   Z-ADD     0             #M                5 0
     C                   Z-ADD     1             #P                5 0
     C                   EXSR      SET_PATH
 
     C     MatchFound    DOWNE     'Y'
     C     #M            ANDGT     0
     C     #M            ANDLE     32767
     C     #_MAPPING(#M) ANDNE     *BLANK
 
     C                   MOVEL     #_MAPPING(#M) MAPPING
 
     C                   EXSR      CHECK_CLAUSES
 
     C     MatchFound    IFEQ      'Y'
     C                   MOVE      Product       O#Product
     C                   ENDIF
     C                   ADD       1             #P
     C                   EXSR      SET_PATH
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SET PATH
      ********************************************************************
     C     SET_PATH      BEGSR
     C                   SELECT
     C     ModuleInput   WHENEQ    'GL'
     C                   Z-ADD     #_GLPATH(#P)  #M
     C     ModuleInput   WHENEQ    'DL'
     C                   Z-ADD     #_DLPATH(#P)  #M
     C     ModuleInput   WHENEQ    'LE'
     C                   Z-ADD     #_LEPATH(#P)  #M
     C     ModuleInput   WHENEQ    'SE'
     C                   Z-ADD     #_SEPATH(#P)  #M
     C                   ENDSL
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * CHECK CLAUSES
      ********************************************************************
     C     CHECK_CLAUSES BEGSR
 
     C                   Z-ADD     1             #C                2 0
     C                   Z-ADD     *ZERO         No_VCmps          2 0
     C                   Z-ADD     *ZERO         No_Cmps           2 0
 
     C     #C            DOWLE     6
     C     #_CLAUSE(#C)  ANDNE     *BLANK
 
     C                   MOVEL     #_CLAUSE(#C)  CLAUSE
     C                   ADD       1             O#CntOfClauses
 
     C                   EXSR      GET_FIELDVALUE
     C                   SELECT
     C     Test          WHENEQ    'EQ'
     C*****Value*****    COMP      InputValue                             99    *            BUG9794
     C     InputValue    COMP      Value                                  99    *            BUG9794
     C     Test          WHENEQ    'NE'
     C*****Value*****    COMP      InputValue                         9999      *            BUG9794
     C     InputValue    COMP      Value                              9999      *            BUG9794
     C     Test          WHENEQ    'GT'
     C*****Value*****    COMP      InputValue                         99        *            BUG9794
     C     InputValue    COMP      Value                              99        *            BUG9794
     C     Test          WHENEQ    'GE'
     C*****Value*****    COMP      InputValue                         99  99    *            BUG9794
     C     InputValue    COMP      Value                              99  99    *            BUG9794
     C     Test          WHENEQ    'LT'
     C*****Value*****    COMP      InputValue                           99      *            BUG9794
     C     InputValue    COMP      Value                                99      *            BUG9794
     C     Test          WHENEQ    'LE'
     C*****Value*****    COMP      InputValue                           9999    *            BUG9794
     C     InputValue    COMP      Value                                9999    *            BUG9794
     C                   ENDSL
 
     C   99              ADD       1             No_VCmps
     C                   ADD       1             No_Cmps
 
     C                   ADD       1             #C
     C                   ENDDO
 
     C     No_VCmps      IFNE      *ZERO
     C     No_VCmps      ANDEQ     No_Cmps
     C                   MOVEL     'Y'           MatchFound
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * GET FIELD VALUE
      ********************************************************************
     C     GET_FIELDVALUEBEGSR
     C                   MOVEL     *BLANK        InputValue       20
     C                   SELECT
     C     Variable      WHENEQ    '01'
     C                   MOVEL     I#AccountCode InputValue
     C     Variable      WHENEQ    '02'
     C                   MOVEL     I#DealType    InputValue
     C     Variable      WHENEQ    '03'
     C                   MOVEL     I#DealSubType InputValue
     C     Variable      WHENEQ    '04'
     C                   MOVEL     I#LoanType    InputValue
     C     Variable      WHENEQ    '05'
     C                   MOVEL     I#LoanSubType InputValue
     C     Variable      WHENEQ    '06'
     C                   MOVEL     I#FacilityTypeInputValue
     C     Variable      WHENEQ    '07'
     C                   MOVEL     I#SecuritySNamInputValue
     C     Variable      WHENEQ    '08'
     C                   MOVEL     I#InvestType  InputValue
     C     Variable      WHENEQ    '09'
     C                   MOVEL     I#Institution InputValue
     C     Variable      WHENEQ    '10'
     C                   MOVEL     I#Industry    InputValue
     C     Variable      WHENEQ    '11'
     C                   MOVEL     I#CtryCitizen InputValue
     C     Variable      WHENEQ    '12'
     C                   MOVEL     I#CtryLocationInputValue
     C     Variable      WHENEQ    '13'
     C                   MOVEL     I#Book        InputValue
     C     Variable      WHENEQ    '14'
     C                   MOVEL     I#BankNonBank InputValue
     C     Variable      WHENEQ    '15'
     C                   MOVEL     I#AssetLiab   InputValue
     C     Variable      WHENEQ    '16'
     C                   MOVEL     I#CollateralTyInputValue
     C                   ENDSL
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#AccountCode    10
     C                   PARM                    I#DealType        2
     C                   PARM                    I#DealSubType     6
     C                   PARM                    I#LoanType        2
     C                   PARM                    I#LoanSubType     6
     C                   PARM                    I#FacilityType    3
     C                   PARM                    I#SecuritySNam   10
     C                   PARM                    I#InvestType      3
     C                   PARM                    I#Institution     2
     C                   PARM                    I#Industry        3
     C                   PARM                    I#CtryCitizen     2
     C                   PARM                    I#CtryLocation    2
     C                   PARM                    I#Book            2
     C                   PARM                    I#BankNonBank     1
     C                   PARM                    I#AssetLiab       1
     C                   PARM                    I#CollateralTy    5
      * OUTPUTS
     C                   PARM                    O#Product        10 0
     C                   PARM                    O#CntOfClauses    5 0
 
      * LOAD MAPPINGS
 
     C                   EXSR      LOAD_MAPPINGS
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * LOAD MAPPINGS
      ********************************************************************
     C     LOAD_MAPPINGS BEGSR
 
      * OVRDBF
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_OVRF
     C                   PARM      80            #MesLen          15 5
      * OPNQRYF
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_OPNQ
     C                   PARM      160           #MesLen
 
     C                   CALLB     'RNLOADMAPU'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           30
      * OUTPUTS
     C                   PARM                    #_MAPPING
     C                   PARM                    #_GLPATH
     C                   PARM                    #_DLPATH
     C                   PARM                    #_LEPATH
     C                   PARM                    #_SEPATH
     C                   PARM                    #_FLDS
      * CLOF
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CLOF
     C                   PARM      80            #MesLen
 
      * Error
 
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN RNLOADMAP'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      ********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
 
     C                   OPEN      QSYSPRT                              99
     C                   EXCEPT    PGMDUMP
     C                   CLOSE     QSYSPRT                              99
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Send a message
      *
     C                   CALL      'AOCREPT'                            9999    *
     C                   PARM      'MEM5051'     #MSGID            7
     C                   PARM      'GBMIDAS '    #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      I#ERMS        #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
     OQSYSPRT   E            PGMDUMP          02
     O                                           75 'RNLOADMAP FAILED'
     O          E            PGMDUMP     1
     O                                           18 'Procedure name    '
     O                       PROC_NAME           50
     O          E            PGMDUMP     1
     O                                           18 'Status code       '
     O                       PGM_STATUS          50
     O          E            PGMDUMP     1
     O                                           18 'Previous status   '
     O                       PRV_STATUS          50
     O          E            PGMDUMP     1
     O                                           18 'Src list line num '
     O                       LINE_NUM            50
     O          E            PGMDUMP     1
     O                                           18 'Routine name      '
     O                       ROUTINE             50
     O          E            PGMDUMP     1
     O                                           18 'Num passed parms  '
     O                       PARMS               50
     O          E            PGMDUMP     1
     O                                           18 'Exception type    '
     O                       EXCP_TYPE           50
     O          E            PGMDUMP     1
     O                                           18 'Exception number  '
     O                       EXCP_NUM            50
     O          E            PGMDUMP     1
     O                                           18 'Program library   '
     O                       PGM_LIB             50
     O          E            PGMDUMP     1
     O                                           18 'Exception data    '
     O                       EXCP_DATA           98
     O          E            PGMDUMP     1
     O                                           18 'Exception Id      '
     O                       EXCP_ID             50
     O          E            PGMDUMP     1
     O                                           18 'Pgm Proc is in    '
     O                       PROC_PGM            50
     O          E            PGMDUMP     1
     O                                           18 'Mod Proc is in    '
     O                       PROC_MOD            50
     O          E            PGMDUMP     1
     O                                           18 'Value of #C       '
     O                       #C            Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #M       '
     O                       #M            Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #P       '
     O                       #P            Z     50
** #_OVRF
OVRDBF FILE(T_FRSMAPR) TOFILE(T_FRSMAPR) SHARE(*YES) SEQONLY(*YES 1000)
** #_OPNQ
OPNQRYF FILE((T_FRSMAPR) (T_FRSPMAP)) FORMAT(T_FRSMAPR) KEYFLD((PMPRIORITY
 *DESCEND))  JFLD((PMRULEID MRRULEID))
** #_CLOF
CLOF OPNID(T_FRSMAPR)
