     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statement - Update Statement Request')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4659 - Midas SE Statement - Update Statement Request       *
      *                                                               *
      *  Function:  This module calculates the next statement date    *
      *             and update the history file.                      *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 CSE040  *CREATE    Date 25Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESDRVL6  UF   E           K DISK    COMMIT      INFSR(*PSSR)
      ** Midas SE Statement - Driver file for Completion
     F                                     PREFIX(HD:2)
 
     FSESTPRL0  UF   E           K DISK    COMMIT      INFSR(*PSSR)
      ** Midas SE Statement Production Request - Main Key
 
     FSESTHSL0  UF   E           K DISK    COMMIT      INFSR(*PSSR)
      ** Midas SE Statement History by Message Reference
 
      ******************************************b**********************
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
 
     D DSGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger data structure passed
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
     D RequestRef      DS
      ** DS used to save the Request Reference
     D   HDDATE
     D   HDRSEQ
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PrvRequest      S                   LIKE(RequestRef)
 
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
 
      ** Read driver file
 
     C     *LOVAL        SETLL     SESDRVL6
     C                   READ      SESDRVL6
 
      ** Till the end of file
 
     C                   DOW       NOT %EOF(SESDRVL6)
 
      ** Update the Request
 
     C                   IF        RequestRef <> PrvRequest
     C                             AND HDFREQ <> 'Z'
     C                   EXSR      $UpRequest
     C                   EVAL      PrvRequest = RequestRef
     C                   ENDIF
 
      ** Update the History of the request
 
     C     HDMREF        CHAIN     SESTHSL0
     C                   IF        %FOUND(SESTHSL0)
     C                             AND SHSTAT = 'PEND'
     C                   EVAL      SHSTAT = 'COMP'                              Complete
     C                   UPDATE    SESTHSD0
     C                   ENDIF
 
      ** Update driver file
 
     C                   EVAL      HDCOMF = 'Y'                                 Complete flag
     C                   UPDATE    SESDRVD0
     C                   COMMIT
 
      ** Read next Driver record
 
     C                   READ      SESDRVL6
 
     C                   ENDDO
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * $UpRequest - Update Request                                        *
      **********************************************************************
     C     $UpRequest    BEGSR
      *    ----------    -----
 
     C     KRequest      CHAIN     SESTPRL0
     C                   IF        %FOUND(SESTPRL0)
 
      ** For Intra-Day, the frequence is daily.
 
     C                   IF        SPFREQ = 'I'
     C                   EVAL      ZFREQ = 'D'
     C                   ELSE
     C                   EVAL      ZFREQ = SPFREQ
     C                   ENDIF
     C                   EVAL      ZMDAY = SPDAYM
     C                   EVAL      ZCCY  = BJCYCD
 
      ** If the Start Date and End Date is inserted,
      ** the Start Date is the last End date + 1 day
      ** and the End Date is computed according the Statement Frequency.
 
     C                   IF        SPMETD <> *Zeros
 
      ** Start Date
 
     C                   EVAL      SPMSTD = SPMETD + 1
 
      ** End Date
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ZFREQ             1
     C     SPMETD        PARM      SPMETD        ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3                        AR702741
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    BJDFIN
     C     DSGELR        PARM                    DSGELR
 
     C                   IF        RetCodeOut <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ZFREQ   '
     C                   EVAL      DBKEY  =  ZFREQ
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
      ** Start Date
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ZFREQ
     C     SPMSTD        PARM      SPMSTD        ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C     DSGELR        PARM                    DSGELR
 
     C                   IF        RetCodeOut <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ZFREQ   '
     C                   EVAL      DBKEY  =  ZFREQ
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Next Statement Date
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ZFREQ             1
     C     SPNSTD        PARM      SPNSTD        ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    BJDFIN
     C     DSGELR        PARM                    DSGELR
 
     C                   IF        RetCodeOut <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ZFREQ   '
     C                   EVAL      DBKEY  =  ZFREQ
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   UPDATE    SESTPRD0
 
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
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
     C     DSBANK        PARM      *Blanks       DSFDY
 
      ** Access General Ledger details
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C*****DSGELR        PARM      *Blanks       DSFDY                                        CGL029
     C     DSGELR        PARM      *BLANKS       DSSDY                                        CGL029
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
      ** Key list to access Request
 
     C     KRequest      KLIST
     C                   KFLD                    HDDATE                         Request Date
     C                   KFLD                    HDRSEQ                         Request Sequence
 
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
(c) Finastra International Limited 2003
