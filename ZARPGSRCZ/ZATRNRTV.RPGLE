     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Transaction number retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZATRNRTV - Next available transaction number retrieval       *
      *                                                               *
      *  Function:  This module gets the next available transaction   *
      *             number for a module (and optionally transaction   *
      *             type) from its transaction number file.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 234300             Date 29Sep06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 222727             Date 05Nov03               *
      *                 212765             Date 10jun03               *
      *                 205226             Date 10Jun03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211504             Date 16Jan03               *
      *                 209554             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201972             Date 08Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184735             Date 23Jan01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 10May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  212765 - Unable to allocate a record in file ZAAVSTPFD.      *
      *  205226 - Problem with program generating duplicate trade     *
      *  211504 - Set on LR to avoid lock on FF and SE trans. files   *
      *  209554 - Problem with pgm generating duplicate FF trade      *
      *  201972 - Produces dump in ZATRNGEN (DBASE 900)               *
      *  184735 - Problem with program generating duplicate trade     *
      *           reference numbers. Additional code added to check   *
      *           SE + FF files and change reference if already used. *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     FZAAVSTPD  UF   E             DISK
     F                                     COMMIT
     FZAAVSDPD  UF   E             DISK
     F                                     COMMIT
     FZAAVFFPD  UF   E             DISK
     F                                     COMMIT
     FTRADHS    IF   E           K DISK                                         184735
     FDPTMVR    IF   E           K DISK                                         184735
     FTRANS2    IF   E           K DISK                                         184735
     FTRADSDY1  IF   E           K DISK                                         184735
     FFFVTRANL1 IF   E           K DISK                                                       209554
     F                                     RENAME(TRANSDF:FFVTRANP0)                          209554
     FSEVTRADL1 IF   E           K DISK                                                       205226
     FSEVDPMVL1 IF   E           K DISK                                                       205226
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Transaction reference
     D Trans_Ref       S              6A
 
      ** Transaction number
     D Trans_Num       S              6S 0
 
      ** Transaction Type                                                                     201972
     D PTRTY           S              1A                                                      201972
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     IZAAVSTD0
     I              TNBR                        Trans_Num
     IZAAVSDD0
     I              TNBR                        Trans_Num
     IZAAVFFD0
     I              TNBR                        Trans_Num
 
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
 
      ** If invalid input paramters, end
 
     C     MODU          IFEQ      'SE'
     C*****TRTY*         ANDEQ     'T'                                                        201972
     C     PTRTY         ANDEQ     'T'                                                        201972
     C     MODU          OREQ      'SE'
     C*****TRTY*         ANDEQ     'D'                                                        201972
     C     PTRTY         ANDEQ     'D'                                                        201972
     C     MODU          OREQ      'FF'
     C                   ELSE
     C                   MOVEL     'Error'       RetCodeIn
     C                   MOVE      *ON           *INLR                                        211504
     C                   RETURN
     C                   END
 
      **  Check for a live record on transaction number file
 
     C     *IN65         DOUEQ     '0'
 
      ** Get next transaction number
 
     C                   EXSR      GETNXT
 
      ** If a live record is found, delete it.
 
     C     *IN65         IFEQ      '0'
 
      ** Delete next transaction number
 
     C                   EXSR      DELNXT
 
      ** Set up the Alpha deal number
 
     C                   MOVE      Trans_Num     Trans_Ref
 
      **  Otherwise, call the transaction number generation program.
 
     C                   ELSE
     C                   CALL      'ZACTRNGNI'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    MODU
     C**********         PARM                    TRTY                                         201972
     C                   PARM                    PTRTY                                        201972
 
      **  If an error occurs in the called program, pass the error back
 
     C     RetCodeOut    IFEQ      'Error'
     C                   MOVE      '0'           *IN65
     C                   MOVEL     'Error'       RetCodeIn
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
      *                                                                                       212765
     C                   UNLOCK    ZAAVSTPD                                                   212765
     C                   UNLOCK    ZAAVSDPD                                                   212765
     C                   UNLOCK    ZAAVFFPD                                                   212765
 
     C                   MOVE      *ON           *INLR                                        211504
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GETNXT - GET NEXT TRANSACTION NUMBER                          *
      *                                                               *
      *****************************************************************
     C     GETNXT        BEGSR
 
     C                   MOVE      '1'           *IN65
 
     C     CHKNUM        TAG                                                                  212765
      *                                                                                       212765
      * READ SE TRADE REFERENCE
 
     C     MODU          IFEQ      'SE'
     C*****TRTY*         ANDEQ     'T'                                                        201972
     C     PTRTY         ANDEQ     'T'                                                        201972
     C     1             SETLL     ZAAVSTPD
     C                   READ      ZAAVSTPD                               65
     C                   END
 
      * READ SE DEPOT MOVEMENT REFERENCE
 
     C     MODU          IFEQ      'SE'
     C*****TRTY*         ANDEQ     'D'                                                        201972
     C     PTRTY         ANDEQ     'D'                                                        201972
     C     1             SETLL     ZAAVSDPD
     C                   READ      ZAAVSDPD                               65
     C                   END
 
      * READ FF TRANSACTION NUMBER
 
     C     MODU          IFEQ      'FF'
     C     1             SETLL     ZAAVFFPD
     C                   READ      ZAAVFFPD                               65
     C                   END
      *                                                                                       212765
      ** End if no record found                                                               212765
      *                                                                                       212765
     C     *IN65         CABEQ     '1'           ENDSUB                                       212765
                                                                                184735
      * Check reference number. If found generate new one and check again.      184735
                                                                                184735
     C*****CHKNUM***     TAG                                                           184735 212765
     C**********         MOVE      *OFF          *IN66                                 184735 212765
     C**********         MOVE      *OFF          *IN67                                 184735 212765
     C**********         MOVE      *OFF          *IN68                                 184735 212765
     C**********         MOVE      *OFF          *IN69                                 184735 212765
     C**********         MOVE      *OFF          *IN70                                 205226 212765
     C**********         MOVE      *OFF          *IN71                                 205226 212765
     C**********         MOVE      *OFF          *IN72                                 209554 212765
     C                   MOVEL     Trans_num     Trans_ref                      184735
     C     MODU          IFEQ      'SE'                                                       212765
     C     PTRTY         ANDEQ     'T'                                                        212765
     C*****Trans_ref***  CHAIN     TRADHS                             66               184735 212765
     C     Trans_ref     CHAIN     TRADHS                             70                      212765
     C     Trans_ref     SETLL     SEVTRADL1                                                  212765
     C     Trans_ref     READE     SEVTRADL1                              71                  212765
     C     *IN70         IFEQ      *OFF                                                       212765
     C     *IN71         OREQ      *OFF                                                       212765
     C                   DELETE    ZAAVSTD0                                                   212765
     C                   GOTO      CHKNUM                                                     212765
     C                   ENDIF                                                                212765
     C                   ENDIF                                                                212765
     C     MODU          IFEQ      'SE'                                                       212765
     C     PTRTY         ANDEQ     'D'                                                        212765
     C*****Trans_ref***  CHAIN     DPTMVR                             67               184735 212765
     C     Trans_ref     CHAIN     DPTMVR                             70                      212765
     C     Trans_ref     SETLL     SEVDPMVL1                                                  212765
     C     Trans_ref     READE     SEVDPMVL1                              71                  212765
     C     *IN70         IFEQ      *OFF                                                       212765
     C     *IN71         OREQ      *OFF                                                       212765
     C                   DELETE    ZAAVSDD0                                                   212765
     C                   GOTO      CHKNUM                                                     212765
     C                   ENDIF                                                                212765
     C                   ENDIF                                                                212765
     C*****Trans_ref***  CHAIN     TRADSDY1                           68               184735 212765
     C*****Trans_num***  CHAIN     TRANS2                             69               184735 212765
     C*****Trans_ref***  SETLL     SEVTRADL1                                           205226 212765
     C*****Trans_ref***  READE     SEVTRADL1                              70           205226 212765
     C*****Trans_ref***  SETLL     SEVDPMVL1                                           205226 212765
     C*****Trans_ref***  READE     SEVDPMVL1                              71           205226 212765
     C     MODU          IFEQ      'FF'                                                       212765
     C     Trans_num     CHAIN     TRANS2                             70                      212765
     C     Trans_num     SETLL     FFVTRANL1                                                  209554
     C*****Trans_num***  READE     FFVTRANL1                              72           209554 212765
     C     Trans_num     READE     FFVTRANL1                              71                  212765
     C     *IN70         IFEQ      *OFF                                                       212765
     C     *IN71         OREQ      *OFF                                                       212765
     C                   DELETE    ZAAVFFD0                                                   212765
     C                   GOTO      CHKNUM                                                     212765
     C                   ENDIF                                                                212765
     C                   ENDIF                                                                212765
     C******IN66***      IFEQ      *OFF                                                184735 212765
     C******IN67***      OREQ      *OFF                                                184735 212765
     C******IN68***      OREQ      *OFF                                                184735 212765
     C******IN69***      OREQ      *OFF                                                184735 212765
     C******IN70***      OREQ      *OFF                                                205226 212765
     C******IN71***      OREQ      *OFF                                                205226 212765
     C******IN72***      OREQ      *OFF                                                209554 212765
     C*****1****         ADD       Trans_num     Trans_num                             184735 212765
     C**********         GOTO      CHKNUM                                              184735 212765
     C**********         ENDIF                                                         184735 212765
 
     C**********         ENDSR                                                                212765
     C     ENDSUB        ENDSR                                                                212765
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELNXT - DELETE NEXT TRANSACTION NUMBER                       *
      *                                                               *
      *****************************************************************
     C     DELNXT        BEGSR
 
      * DELETE SE TRADE REFERENCE
 
     C     MODU          IFEQ      'SE'
     C*****TRTY*         ANDEQ     'T'                                                        201972
     C     PTRTY         ANDEQ     'T'                                                        201972
     C                   DELETE    ZAAVSTD0
     C                   END
 
      * DELETE SE DEPOT MOVEMENT REFERENCE
 
     C     MODU          IFEQ      'SE'
     C*****TRTY*         ANDEQ     'D'                                                        201972
     C     PTRTY         ANDEQ     'D'                                                        201972
     C                   DELETE    ZAAVSDD0
     C                   END
 
      * DELETE FF TRANSACTION NUMBER
 
     C     MODU          IFEQ      'FF'
     C                   DELETE    ZAAVFFD0
     C                   END
 
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
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    MODU              2
     C**********         PARM                    TRTY              1                          201972
     C                   PARM                    PTRTY                                        201972
     C                   PARM                    Trans_Ref
     C                   PARM                    Trans_Num
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
