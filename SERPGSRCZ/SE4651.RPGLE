     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statement - Select Request for Production')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4651 - Midas SE Statement - Select Request for Production  *
      *                                                               *
      *  Function:  This module process the statement production req. *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE040   *CREATE   Date 07Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESTPRL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Statement Production Request - Index
 
     FSESDRVL1  IF   E           K DISK    RENAME(SESDRVD0:SESDRVD1)
      ** Midas SE Statement - Driver file by Request
     F                                     PREFIX(L1_)  INFSR(*PSSR)
 
     FSESDRVPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Statement - Driver file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*Dta_MPHAS*****E DS                  EXTNAME(MPHAS)  DTAARA(MPHAS)                      CCB020
      ***Midas*SC*Phase*of*day                                                                CCB020
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D CurrTime        S              6  0                                      Current Time
 
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
 
     C                   TIME                    CurrTime                       Current Time
 
      ** Read Statement Production Request
 
     C     *LOVAL        SETLL     SESTPRL2
     C                   READ      SESTPRL2
 
      ** Till the end of file
 
     C                   DOW       NOT %EOF(SESTPRL2)
 
      ** Process the Production Request
 
      **   According the Request Status
 
     C                   IF        SPCHTP <> 'X'                                Authorize
     C                   GOTO      NextRequest
     C                   ENDIF
 
      **   According the frequency and Midas phase
 
     C**********         IF        MPHAS = 'A'                                  Input Cycle   CCB020
     C                   IF        COBST = '*NO'                                Input Cycle   CCB020
     C                             AND SPFREQ <> 'I'                            Intra Day
     C                             AND SPFREQ <> 'Z'                            Ad-hoc
     C**********                   OR  MPHAS  <> 'A'                        Close of Business CCB020
     C                             OR  COBST  = '*YES'                                        CCB020
     C                             AND SPFREQ =  'I'
     C**********                   OR  MPHAS  <> 'A'                        Close of Business CCB020
     C                             OR  COBST  = '*YES'                                        CCB020
     C                             AND SPFREQ =  'Z'
     C                   GOTO      NextRequest
     C                   ENDIF
 
      **   According the Next Statement date
 
     C                   IF        SPNSTD > BJDNWD - 1
     C                   GOTO      NextRequest
     C                   ENDIF
 
      **   According the Next Statement Time
 
     C                   IF            SPFREQ =  'I'
     C                             AND SPNSTT >  CurrTime                       Next Statement Time
     C                   GOTO      NextRequest
     C                   ENDIF
 
      **   Avoid to extract twice the same request
 
     C     KRequest      SETLL     SESDRVL1
     C                   IF        %EQUAL
     C                   GOTO      NextRequest
     C                   ENDIF
 
      **   Add the Request in the Driver file
 
     C                   EVAL      SPEXTR = *ZEROS                              Extract Reference
     C                   EVAL      SPEXTF = *BLANKS                             Extract Flag
     C                   EVAL      SPSETF = *BLANKS                             Setup Flag
     C                   EVAL      SPGENF = *BLANKS                             Generate Flag
     C                   EVAL      SPCOMF = *BLANKS                             Complete Flag
 
     C                   WRITE     SESDRVD0
     C                   COMMIT
 
     C     NextRequest   TAG
 
      ** Read next Statement Production Request
 
     C                   READ      SESTPRL2
 
     C                   ENDDO
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * $ExitMod  - Exit from the module                                   *
      **********************************************************************
 
     C     $ExitMod      BEGSR
      *    ---------     -----
 
     C                   MOVE      *On           *INLR
     C                   RETURN
 
      *                  -----
     C                   ENDSR
      **********************************************************************
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
      *    ------        -----
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     DSBANK        PARM      DSBANK        DSFDY
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
      ***Retrieve*the*Midas*Phase                                                             CCB020
 
     C**********         IN        Dta_MPHAS                                                  CCB020
      *                                                                                       CCB020
      ** CBFLAGQT Phase Check                                                                 CCB020
      *                                                                                       CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       COBST             4                          CCB020
 
      ** Key list to access Request
 
     C     KRequest      KLIST
     C                   KFLD                    SPDATE                         Request Date
     C                   KFLD                    SPRSEQ                         Request Sequence
 
      *                  -----
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
      *    -----         -----
 
     C                   DUMP
 
     C                   EVAL      ReturnCode = '*ERROR*'
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *                  -----
     C                   ENDSR
 
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
