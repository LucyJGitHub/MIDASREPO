     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Statement - Drop Statement request')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Strading Module                           *
      *                                                               *
      *  SE4662 - Midas SE Statement - Drop Statement Request         *
      *                                                               *
      *  Function:  This program suppress the Ah-Doc request and      *
      *             deleted request.                                  *
      *                                                               *
      *  Called By   : SEC4662 - SE Statement Processing - Drop reqs. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE040   *CREATE   Date 07Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     FSESTPRL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Statement Production Request
 
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
 
      ** Read Statement Production Request
 
     C     *LOVAL        SETLL     SESTPRL1
     C                   READ      SESTPRL1
 
      ** Till the end of file
 
     C                   DOW       NOT %EOF(SESTPRL1)
 
      ** Suppress deleted request or Ad-Hoc request
 
     C                   IF        SPCHTP = 'D'                                 Delete request
     C                             OR SPFREQ = 'Z'                              Ad-Hoc request
     C                   DELETE    SESTPRD0
     C                   ENDIF
 
      ** Read next Statement Production Request
 
     C                   READ      SESTPRL1
 
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
 
     C                   CALL      'DBERRCTL'
 
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
