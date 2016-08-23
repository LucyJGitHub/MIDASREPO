     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate reference rate')
      *****************************************************************
      *                                                               *
      *  Midas - Validate Reference Rate Module                       *
      *                                                               *
      *  IRVREFRATE                                                   *
      *                                                               *
      *  Function:  This module validates a received reference rate.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CSD006             Date 15May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
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
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                    S01194
 
     D** RECORD FORMATS FOR ACCESS TO BASE RATE DETAILS                   S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D** RECORD FORMATS FOR ACCESS TO BASE RATE DETAILS                         CSD006
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CSD006
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
 
      ** Reference Rate
     D SRFRTE          S              2A
 
      ** Deal Currency
     D SUCUCY          S              3A
 
      ** (our) currency
     D SucucyOK        S              1A
 
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
     C* Validate Ref Base Rate Code
 
     C     SRFRTE        IFEQ      *BLANK
     C                   MOVE      'MMA0013'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C*
     C     SRFRTE        IFNE      *BLANK
     C     SUCUCYok      ANDEQ     'Y'
      *
     C** Call Access Program for Base Rate Details
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @CCY              3
     C                   PARM      SRFRTE        @BBSRT            2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'MMA0014'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C                   MOVEL     BACYCD        SUCUCY
     C                   MOVEL     BABSRC        SRFRTE
     C                   END
     C                   END
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
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
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SRFRTE
     C                   PARM                    SUCUCY
     C                   PARM                    SUCUCYok
     C                   PARM                    SDBSRT
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
