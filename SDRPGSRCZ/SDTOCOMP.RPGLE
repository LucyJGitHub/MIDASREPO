     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD MMM to Compliance interface')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDTOCOMP - Compliance to MMM Interface                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3641 *Create    Date 07Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3641- Globa MMM/Compliance Interface                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc      - Main Processing                                *
      *  SRSndToComp - Send Formatted Data to Compliance Data Queue   *
      *  *INZSR      - Initialise                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DS for Midas Watch List Message Details Queue
     D SDWLMEDS      E DS                  EXTNAME(SDWLMEPD)
 
      ** DS for Midas SD Data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5  0
     D PDtqWait        S              5  0
     D PWaitTime       S              6A
     D PDtqData        S          31000A
     D PDtqKey         S              2A
     D PKeyLen         S              3  0
     D @END            S              3A
     D HostId          S              2A
     D NodeRef         S              2A
     D MsgPty          S              2A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      ** While Dataqueue data is not 'END'
 
     C                   DOW       @END    <> 'END'
 
     C                   EVAL      PDtqLen = 31000
     C                   EVAL      PKeyLen = 2
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM      'SDTOCOMP'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqData
     C                   PARM                    PDtqWait
     C                   PARM      'EQ'          PKeyOrdr          2
     C                   PARM                    PKeyLen
     C                   PARM                    PDtqKey
     C                   PARM                    PSndLen           3 0
     C                   PARM                    PSndInfo         45
 
     C                   MOVEL     PDtqData      SDWLMEDS
     C                   MOVEL     W7IDEN        @END
 
     C                   IF        @END   <> 'END'
 
      ** Send to MMM Data Queue
 
     C                   EXSR      SRSndToComp
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** End of program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndToComp - Send Formatted Data to Compliance Data Queue   *
      *                                                               *
      *****************************************************************
     C     SRSndToComp   BEGSR
 
      ** Write Data to MMM Keyed Data Queue
     C                   EVAL      PDtqLen = 31000
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWMDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Retrieve details of data area SDSTAT
 
     C                   IN        SDSTAT
 
      ** Initialise Data queue parameters
 
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqKey = LIBR
 
      *********************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
