     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Get Next Available JE Batch Number')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  ZAGENBTCHN - Get Next Available JE Batch Number              *
      *                                                               *
      *  Function: This module obtains the next available batch       *
      *************number from the file GLJENHPD.**********************         186206
      *            number from the file GLBTNOPD.                     *         186206
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. JMI111             Date 18May18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038             Date 10May05               *
      *                 216612             Date 07Apr03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212636             Date 07Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186206             Date 26Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *           Added hooks JMI111_006, JMI111_012, JMI111_013,     *
      *                       JMI111_014                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  216612 - Condition 212636 on TI module switched on.          *
      *  212636 - Take into account the reserved TI batch number      *
      *           range when determining the next free batch number.  *
      *  186206 - Journal Entry API fixes. Produce only one dump      *
      *           per JE batch. Generate JE Valid errors report.      *
      *           Prevent record locking error in JE database         *
      *           updater.                                            *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** JE Headers logical file - retrieve
     F***GLJENHL1  IF   E           K DISK    INFSR(*PSSR)                      186206
     FGLBTNOL0  IF   E           K DISK    INFSR(*PSSR)                         186206
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
       /COPY WNCPYSRC,JMI111_006                                                              JMI111
      *                                                                                       JMI111
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  212636
      **  External data structure for TI A/C ICD Details                                      212636
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     212636
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    212636
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  212636
      ** EXTERNAL DS FOR MODULE ID DETAILS                                                    212636
     D PErrorFlag      S              1
     D PBTNB           S              3
      *                                                                                       JMI111
       /COPY WNCPYSRC,JMI111_012                                                              JMI111
      *                                                                                       JMI111
     D WBTNB           S              3  0
     D WBRBT           S              3  0
     D WIDX            S              3  0
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
      ** Reset fields.
      *
     C                   MOVE      'N'           PErrorFlag
     C                   CLEAR                   PBTNB
     C                   CLEAR                   WBTNB
     C                   CLEAR                   WBRBT
     C                   CLEAR                   WIDX
      *                                                                                       212636
      *  Retrieve TI Details                                                                  212636
      *                                                                                       212636
     C     BGN3ST        IFEQ      'Y'                                                        216612
     C                   CALL      'AOTIINR0'                                                 212636
     C                   PARM      '*MSG'        WWRTCD            7                          212636
     C                   PARM      '*FIRST'      WWOPTN            7                          212636
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        212636
      *   Error?                                                                              212636
     C     WWRTCD        IFNE      *BLANKS                                                    212636
     C                   MOVEL     '*FIRST'      DBKEY                                        212636
     C                   MOVEL     'SDTIINPD'    DBFILE                                       212636
     C                   Z-ADD     2             DBASE                                        212636
     C                   EXSR      *PSSR                                                      212636
     C                   ENDIF                                                                212636
     C                   ENDIF                                                                216612
      *
      ** Determine last batch number from file.
      *
     C******HIVAL        SETLL     GLJENHL1                                     186206
     C******             READP     GLJENHL1                               01    186206
     C     *HIVAL        SETLL     GLBTNOL0                                     186206
     C                   READP     GLBTNOL0                               01    186206
      *
      ** Next batch number is last batch number + 1.  If no batch
      ** exists, batch no. is set to 1.
      *
     C     *IN01         IFEQ      *OFF
     C*****              MOVE      BRBTNB        WBTNB                          186206
     C                   MOVE      B3BTNB        WBTNB                          186206
     C                   ENDIF
      *
     C                   ADD       1             WBTNB
      * Consider TI batch no.                                                                 212636
     C*****BGN3ST        IFGE      'Y'                                                 212636 216612
     C     BGN3ST        IFEQ      'Y'                                                        216612
     C     WBTNB         ANDGE     TILRBN                                                     212636
     C     WBTNB         ANDLE     TIURBN                                                     212636
      * Assign next batch no. after TI batch no. allocation.                                  212636
     C     TIURBN        ADD       1             WBTNB                                        212636
     C                   ENDIF                                                                212636
      *                                                                                       JMI111
       /COPY WNCPYSRC,JMI111_013                                                              JMI111
      *                                                                                       JMI111
      *
      ** If next batch no. is 0 (last batch is 999), determine
      ** if there are batch number gaps.
      *
     C     WBTNB         IFEQ      *ZERO
     C                   EXSR      SRBTGP
     C                   ENDIF
      *
     C                   MOVE      WBTNB         PBTNB
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  STBTGP - Determine if there are batch number gaps            *
      *                                                               *
      *****************************************************************
      *
     C     SRBTGP        BEGSR
      *
     C                   Z-ADD     1             WIDX
      *
     C******LOVAL        SETLL     GLJENHL1                                     186206
     C*****              READ      GLJENHL1                               01    186206
     C     *LOVAL        SETLL     GLBTNOL0                                     186206
     C                   READ      GLBTNOL0                               01    186206
      *
     C     WBTNB         DOWEQ     *ZERO
     C     *IN01         ANDEQ     *OFF
      *
     C*****              MOVE      BRBTNB        WBRBT                          186206
     C                   MOVE      B3BTNB        WBRBT                          186206
      *
     C     WBRBT         IFEQ      WIDX
     C                   ADD       1             WIDX
     C*****              READ      GLJENHL1                               01    186206
     C                   READ      GLBTNOL0                               01    186206
     C                   ELSE
      * Check TI batch no. range                                                              212636
     C     BGN3ST        IFEQ      'Y'                                                        212636
     C     WIDX          ANDGE     TILRBN                                                     212636
     C     WIDX          ANDLE     TIURBN                                                     212636
     C     TIURBN        ADD       1             WIDX                                         212636
     C                   MOVE      WIDX          WIDA              3                          212636
     C     WIDA          CHAIN     GLBTNOL0                           01                      212636
     C                   ELSE                                                                 212636
     C                   Z-ADD     WIDX          WBTNB
     C                   ENDIF                                                                212636
     C                   ENDIF
      *
     C                   ENDDO
      *                                                                                       JMI111
      /COPY WNCPYSRC,JMI111_014                                                               JMI111
      *                                                                                       JMI111
      ** If no available batch number, then error in return
      ** retuen code.
      *
     C     WBTNB         IFEQ      *ZERO
     C                   MOVE      'Y'           PErrorFlag
     C                   ENDIF
      *
     C                   ENDSR
      *
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
     C                   PARM                    PErrorFlag
     C                   PARM                    PBTNB
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      *                                                                                       212636
      ** ACCESS MODULE ID DETAILS                                                             212636
      *                                                                                       212636
     C                   CALLB     'AOMMODR0'                                                 212636
     C                   PARM      *BLANKS       @RTCD                                        212636
     C                   PARM      '*FIRST '     @OPTN                                        212636
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        212636
      *                                                                                       212636
      * DATABASE ERROR                                                                        212636
      *                                                                                       212636
     C     @RTCD         IFNE      *BLANK                                                     212636
     C                   MOVEL     @OPTN         DBKEY                                        212636
     C                   MOVEL     'SDMMODPD'    DBFILE                                       212636
     C                   MOVEL     '902'         DBASE                                        212636
     C                   EXSR      *PSSR                                                      212636
     C                   END                                                                  212636
      *                                                                                       212636
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
