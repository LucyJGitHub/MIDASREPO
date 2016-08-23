     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RN Load (Product) Mappings')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNLOADMAP - Load (Product) Mappings                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FT_FRSMAPR IP   E             DISK    INFSR(*PSSR) rename(T_FRSMAPR:DET)
     FT_FRSPMAP IF   E           K DISK    INFSR(*PSSR) rename(T_FRSPMAP:HED)
     FGPPDWNL0  IF   E           K DISK    INFSR(*PSSR)
     FQSYSPRT   O    F  132        PRINTER INFSR(*PSSR)  USROPN
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
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
 
     IDET
     I                                          MRRULEID      L1
 
     C     PKEY          KLIST
     C                   KFLD                    MRRULEID
     C                   KFLD                    RULESET
     C
     C                   Z-ADD     1             RULESET           5 0
 
     C   L1              EXSR      ADD_MAPPING
     C   L1PKEY          CHAIN     HED                                60
 
     C     *IN60         IFEQ      *OFF
 
     C     #C            IFEQ      6
     C     MRANDOR       OREQ      'O'
     C                   EXSR      ADD_MAPPING
     C                   ENDIF
 
     C                   EXSR      ADD_CLAUSE
     C                   ENDIF
 
     CLR                 EXSR      ADD_MAPPING
 
     C/SPACE 5
      ********************************************************************
      * ADD CLAUSE
      ********************************************************************
     C     ADD_CLAUSE    BEGSR
 
     C                   MOVE      PMPRODID      Product
 
     C                   Z-ADD     1             #F                2 0
     C     MRVARIABLE    LOOKUP    #_FLDS(#F)                             99
     C   99              MOVE      #F            Variable
     C  N99              MOVE      '00'          Variable
 
     C                   EXSR      LOG_REFERENCES
 
     C                   MOVE      MRTEST        Test
 
     C                   MOVE      MRVALUE       Value
 
     C                   ADD       1             #C                2 0
     C                   MOVEL     CLAUSE        #_CLAUSE(#C)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * ADD MAPPING
      ********************************************************************
     C     ADD_MAPPING   BEGSR
     C     MAPPING       IFNE      *BLANK
     C                   ADD       1             #M                5 0
     C     #M            IFLE      32767
     C                   EXSR      UPDATE_PATHS
     C                   MOVEL     MAPPING       #_MAPPING(#M)
     C                   ENDIF
     C                   MOVEL     *BLANK        MAPPING
     C                   MOVEL     'N'           Refto_GL
     C                   MOVEL     'N'           Refto_DL
     C                   MOVEL     'N'           Refto_LE
     C                   MOVEL     'N'           Refto_SE
     C                   ENDIF
     C                   Z-ADD     0             #C                2 0
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * LOG REFERENCES
      ********************************************************************
     C     LOG_REFERENCESBEGSR
 
      * Account Code, Collateral Type
 
     C     Variable      IFEQ      '01'
     C     Variable      OREQ      '16'
     C                   MOVEL     'Y'           Refto_GL          1
     C                   ENDIF
 
      * Deal Type, Deal Sub-Type
 
     C     Variable      IFEQ      '02'
     C     Variable      OREQ      '03'
     C                   MOVEL     'Y'           Refto_DL          1
     C                   ENDIF
 
      * Loan Type, Loan Sub-Type, Facility Type
 
     C     Variable      IFEQ      '04'
     C     Variable      OREQ      '05'
     C     Variable      OREQ      '06'
     C                   MOVEL     'Y'           Refto_LE          1
     C                   ENDIF
 
      * Security Shortname, Investment Type
 
     C     Variable      IFEQ      '07'
     C     Variable      OREQ      '08'
     C                   MOVEL     'Y'           Refto_SE          1
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * UPDATE PATHS
      ********************************************************************
     C     UPDATE_PATHS  BEGSR
     C     Refto_GL      IFEQ      'Y'
     C                   ADD       1             #GLP              5 0
     C                   Z-ADD     #M            #_GLPATH(#GLP)
     C                   ENDIF
     C     Refto_DL      IFEQ      'Y'
     C                   ADD       1             #DLP              5 0
     C                   Z-ADD     #M            #_DLPATH(#DLP)
     C                   ENDIF
     C     Refto_LE      IFEQ      'Y'
     C                   ADD       1             #LEP              5 0
     C                   Z-ADD     #M            #_LEPATH(#LEP)
     C                   ENDIF
     C     Refto_SE      IFEQ      'Y'
     C                   ADD       1             #SEP              5 0
     C                   Z-ADD     #M            #_SEPATH(#SEP)
     C                   ENDIF
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
      * OUTPUTS
     C                   PARM                    #_MAPPING
     C                   PARM                    #_GLPATH
     C                   PARM                    #_DLPATH
     C                   PARM                    #_LEPATH
     C                   PARM                    #_SEPATH
     C                   PARM                    #_FLDS
 
      * Load Field Descriptions
 
     C                   EXSR      LOAD_FLD_DESC
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Load Field Descriptions
      ********************************************************************
     C     LOAD_FLD_DESC BEGSR
     C     PDWNK         KLIST
     C                   KFLD                    GLHIND
 
     C                   Z-ADD     40            GLHIND
 
      * Clear Reference ID SubFields & Sizes
 
     C                   Z-ADD     1             #F                2 0
     C     PDWNK         SETLL     SDPDWND0
     C     PDWNK         READE     SDPDWND0                               99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     GLDESC        #_FLDS(#F)
     C                   ADD       1             #F
     C     PDWNK         READE     SDPDWND0                               99
     C                   ENDDO
 
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
     O                                           18 'Value of #F       '
     O                       #F            Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #M       '
     O                       #M            Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #GLP     '
     O                       #GLP          Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #DLP     '
     O                       #DLP          Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #LEP     '
     O                       #LEP          Z     50
     O          E            PGMDUMP     1
     O                                           18 'Value of #SEP     '
     O                       #SEP          Z     50
