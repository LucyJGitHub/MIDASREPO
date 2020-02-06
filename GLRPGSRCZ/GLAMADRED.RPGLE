     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Details Read')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADRED - GL Account Details Read                          *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the accounts file.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 12Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** RE Account Numbers file
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)
 
      ** GL Account by branch file
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D AFLD10          S              1    DIM(10)
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)
 
     D                 DS
     D***ACKEY**                1     18                                                      CGL029
     D  ACKEY                  1     24                                                       CGL029
     D  WWBRCA                 1      3
     D  WWCNUM                 4      9
     D  WWCCY                 10     12
     D***WWACOD*               13     16                                                      CGL029
     D***WWACSQ*               17     18                                                      CGL029
     D  WWACOD                13     22                                                       CGL029
     D  WWACSQ                23     24                                                       CGL029
     D  WWACNO                 1     10  0
     D  RETKY                  1     10
     D***ACCKY**               11     18                                                      CGL029
     D  ACCKY                 11     24                                                       CGL029
 
     D                 DS
     D***ACNUMB*                1     18                                                      CGL029
     D  ACNUMB                 1     24                                                       CGL029
     D  BRCA                   1      3
     D**CNUM****               4      9  0                                                    CSD027
     D  CNUM                   4      9A                                                      CSD027
     D  CCY                   10     12
     D***ACOD***               13     16  0                                                   CGL029
     D***ACSQ***               17     18  0                                                   CGL029
     D  ACOD                  13     22  0                                                    CGL029
     D  ACSQ                  23     24  0                                                    CGL029
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DDACNO          S             24                                                       CGL029
     D @ACRED          S             24                                                       CGL029
     D WACOD4          S             10S 0                                                    CGL029
                                                                                              CGL029
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
      * INITIALIZE OUTPUTS
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @ACRED
     C                   MOVEL     *BLANK        @RERED
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE ACCOUNT NO. (FOR POINTER)
      *
     C                   EXSR      VALACNO
      *
      * READ FORWARDS
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * READ BACKWARDS
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH ACCOUNTS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C     ACKEY         IFEQ      *BLANKS
     C     *LOVAL        SETGT     ACCNTLXX
     C                   ELSE
     C     WKACBR        SETGT     ACCNTLXX
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C*****CNUM*         ORNE      *ZERO                                                      CSD027
     C     CNUM          ORNE      *BLANKS                                                    CSD027
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read
     C                   READ      ACCNTLXX                               99
      *
      * If multi-branching, check if authorized to look at Account (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDACNO        IFEQ      *BLANKS
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   ENDIF
      *
      * Else, return the account number read
      *
     C                   ELSE
     C                   MOVE      ACNUMB        @ACRED
     C     ATYP          IFEQ      'R'
     C                   MOVE      ACNO          @RERED
     C                   ELSE
     C                   MOVE      *BLANKS       @RERED
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH ACCOUNTS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C     ACKEY         IFEQ      *BLANKS
     C     *LOVAL        SETLL     ACCNTLXX
     C                   ELSE
     C     WKACBR        SETLL     ACCNTLXX
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C*****CNUM*         ORNE      *ZERO                                                      CSD027
     C     CNUM          ORNE      *BLANKS                                                    CSD027
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read
      *
     C                   READP     ACCNTLXX                               99
      *
      * If multi-branching, check if authorized to look at account (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the account number read
      *
     C                   ELSE
     C                   MOVE      ACNUMB        @ACRED
     C     ATYP          IFEQ      'R'
     C                   MOVE      ACNO          @RERED
     C                   ELSE
     C                   MOVE      *BLANKS       @RERED
     C                   ENDIF
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACNO - VALIDATE ACCOUNT NUMBER POINTER
      *****************************************************************
     C     VALACNO       BEGSR
      *
     C                   MOVE      DDACNO        ACKEY
      *
      ** RETAIL
     C     ACCKY         IFEQ      *BLANKS
     C     RETKY         ANDNE     *BLANKS
      *
     C                   MOVEA     RETKY         AFLD10
     C                   Z-ADD     1             IDX1              2 0
     C                   SETON                                            80
      *
     C     IDX1          DOWLT     11
     C     *IN80         ANDEQ     '1'
     C     AFLD10(IDX1)  LOOKUP    NUM                                    80
     C                   ADD       1             IDX1
     C                   ENDDO
      *
      ** If Retail Number used, get the Account Number
     C     *IN80         IFEQ      '1'
     C     WWACNO        SETLL     ACNUM
     C                   READ      ACNUM                                  89
     C     *IN89         IFEQ      *OFF
     C                   MOVE      BRCA          WWBRCA
     C                   MOVE      CNUM          WWCNUM
     C                   MOVE      CCY           WWCCY
     C                   MOVE      ACOD          WWACOD
     C                   MOVE      ACSQ          WWACSQ
     C                   MOVE      ACKEY         DDACNO
     C                   ELSE
     C                   MOVE      *BLANKS       DDACNO
     C                   MOVE      *BLANKS       ACKEY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** GENERAL LEDGER
     C     ACKEY         IFNE      *BLANKS
      *
     C                   MOVE      WWCNUM        WCNUM6
     C*****WCNUM6        IFLT      *ZERO                                                      CSD027
     C     WCNUM6        IFLT      *BLANKS                                                    CSD027
     C                   MOVE      *LOVAL        WCNUM6
     C                   ENDIF
      *
     C                   MOVE      WWACOD        WACOD4
     C     WACOD4        IFLT      *ZERO
     C                   MOVE      *LOVAL        WACOD4
     C                   ENDIF
      *
     C                   MOVE      WWACSQ        WACSQ2
     C     WACSQ2        IFLT      *ZERO
     C                   MOVE      *LOVAL        WACSQ2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
      * Account Number
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C**********         PARM                    DDACNO           18                          CGL029
     C                   PARM                    DDACNO                                       CGL029
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      * OUTPUT PARAMETERS :
      * Error meassage
      * Account No. Read
      * Retail No. Read
     C                   PARM                    @ERRMS            7
     C**********         PARM                    @ACRED           18                          CGL029
     C                   PARM                    @ACRED                                       CGL029
     C                   PARM                    @RERED           10
      *
     C     WKACBR        KLIST
     C                   KFLD                    WWBRCA
     C**********         KFLD                    WCNUM6            6 0                        CSD027
     C                   KFLD                    WCNUM6            6                          CSD027
     C                   KFLD                    WWCCY
     C**********         KFLD                    WACOD4            4 0                        CGL029
     C                   KFLD                    WACOD4                                       CGL029
     C                   KFLD                    WACSQ2            2 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'GLAMADRED '  DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
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
(c) Finastra International Limited 2001
** NUM
0123456789
