     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update Change User on GPCURRPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00219 - Midas SM Update Change User on GPCURRPD           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD031342           Date 24Nov14               *
      *                 CFB001  *CREATE    Date 12Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031342 - Error encountered when running from Bridge.       *
      *  CFB001 - FusionBanking Midas Rebranding                      *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     FGPCURRPD  UF   E             DISK
 
     FSMU00219P1O    E             PRINTER INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY GPCPYSRCG,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY GPCPYSRCG,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Area giving Installation Control Details
     D SDBANK        E DS                  EXTNAME(GZSDBANKPD)
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for Access Program
     D SPOOL1          DS
     D  OFFLN                188    189B 0
     D  CURLIN               367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Bank details parameters
     D  PRTCD          S              7A
     D  POPTN          S              7A
 
     D  PNORE          S              5  0
     D  RNUPDT         S              5  0
     D  MODE           S              1A
     D  @RUN           S              1A   INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     1             SETLL     GPCURRPD
     C                   READ      GPCURRPD
     C                   DOW       NOT %EOF
 
     C                   IF        GCCUSR = 'BANKFUSION'
 
     C                   EVAL      PNORE = PNORE + 1
 
      ** For Update Mode
 
     C                   IF        *IN14 = *ON
     C                   EVAL      POCGUS = GCCUSR
     C                   EVAL      GCCUSR = '          '
     C                   UPDATE    GPCURRD0
     C                   EVAL      PSTAT = 'UPDATED'
     C                   EVAL      PNCGUS = '          '
     C                   EVAL      RNUPDT = RNUPDT + 1
 
     C                   ELSE
 
      ** For Audit Mode
 
     C                   EVAL      PSTAT = *BLANKS
     C                   EVAL      POCGUS = GCCUSR
     C                   EVAL      PNCGUS = *BLANKS
 
     C                   ENDIF
 
     C                   EVAL      PCCYCD = GCCYCD
     C                   EVAL      PDESC = GCDESC
 
     C                   Z-ADD     2             RQDLIN            3 0
     C     OFFLN         SUB       CURLIN        AVALIN            3 0
     C     AVALIN        IFLT      RQDLIN
     C                   WRITE     HEADER
     C                   ENDIF
     C                   WRITE     DETAIL
 
     C                   ENDIF
 
     C                   READ      GPCURRPD
     C                   ENDDO
 
     C                   EXSR      AUDIT
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AUDIT - Write trailer                                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     AUDIT         BEGSR
 
     C                   IF        PNORE = 0
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   WRITE     TRAILER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    MODE
 
      ** Check if for Update or for Audit Only
 
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   EVAL      *IN14 = *ON
     C                   ELSE
     C                   EVAL      *IN14 = *OFF
     C                   ENDIF
 
      ***Access*Bank*Details*******************************************                     MD031342
 
     C**********         CALL      'AOBANKR0'                                               MD031342
     C**********         PARM      *BLANKS       PRTCD                                      MD031342
     C**********         PARM      '*FIRST'      POPTN                                      MD031342
     C*****SDBANK        PARM      SDBANK        DSFDY                                      MD031342
 
     C**********         IF        PRTCD <> *BLANKS                                         MD031342
     C******LOCK         IN        LDA                                                      MD031342
     C**********         EVAL      DBKEY = POPTN                                            MD031342
     C**********         EVAL      DBFILE = 'GZSDBANKPD'                                    MD031342
     C**********         EVAL      DBPGM = 'SMU00219'                                       MD031342
     C**********         EVAL      DBASE = 001                                              MD031342
     C**********         EXSR      *PSSR                                                    MD031342
     C**********         ENDIF                                                              MD031342
 
     C                   EVAL      PNORE = 0
     C                   EVAL      RNUPDT = 0
 
     C                   WRITE     HEADER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C**********         CALL      'DBERRCTL'                                               MD031342
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
