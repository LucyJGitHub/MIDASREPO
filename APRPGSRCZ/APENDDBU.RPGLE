     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP End the API database updaters')               *
      *****************************************************************
      *                                                               *
      *  Midas - API Module                                           *
      *                                                               *
      *  APENDDBU - End the API Database Updaters                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER034A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239136             Date 19Jul06               *
      *                 CAP183             Date 05Jan06               *
      *                 CGL032             Date 05Jul04               *
      *                 CAS009             Date 04May04               *
      *                 CAP084             Date 08Sep03               *
      *                 CAP079             Date 19Aug02               *
      *                 CAP078             Date 31Oct02               *
      *                 CAP077             Date 19Aug02               *
      *                 CAP076             Date 26Mar02               *
      *                 CAP075             Date 12Aug02               *
      *                 CAP074             Date 26Mar02               *
      *                 CAP073             Date 18May02               *
      *                 CSE040             Date 28Mar03               *
      *                 CAP182             Date 14Mar03               *
      *                 CSE039             Date 07Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015  *CREATE    Date 29May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,APH00016                                 *
      *             WNCPYSRC,APH00017                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  239136 - Include DLFE paramater when calling APCENDDBU to    *
      *           end DBU_DLFE job.                                   *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs                               *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAP084 - APCENDDBU2 renamed to APCENDDBU3 in line with the   *
      *           equivalent APCSTR program.                          *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *  CAP078 - Lending API enhancements - Fee input                *
      *  CAP077 - Lending API enhancements - Manual payments          *
      *  CAP076 - Lending API enhancements - Rollover Instructions    *
      *  CAP075 - Lending API enhancements - Loan amendments          *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details.    *
      *  CSE040 - Securities Statement Processing                     *
      *  CAP182 - Automatic Settlement of Trades                      *
      *         - Conversion of SE Trade Settlement Input maintenance *
      *           function to modular structure to use as APIs.       *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CPK015 - New module introuced to replace APCENDDBU as the    *
      *           CPP for ENDAPIDBU as APCENDDBU is approaching the   *
      *           IBM parameter limit (40).                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D DLFE            S              1A                                                      CAS009
     D CUAH            S              1A                                                     CER034A
 
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
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
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
 
     C     *entry        PLIST
     C                   PARM                    SYSTEM            2
     C                   PARM                    LDNI              1
     C                   PARM                    DEAM              1
     C                   PARM                    NASP              1
     C                   PARM                    NASS              1
     C                   PARM                    FXDL              1
     C                   PARM                    FRA               1
     C                   PARM                    SIRS              1
     C                   PARM                    CIRS              1
     C                   PARM                    DPMV              1
     C                   PARM                    TRAD              1
     C                   PARM                    TRAN              1
     C                   PARM                    INTC              1
     C                   PARM                    FWRT              1
     C                   PARM                    INTR              1
     C                   PARM                    PRCS              1
     C                   PARM                    PFDM              1
     C                   PARM                    BITH              1
     C                   PARM                    BITP              1
     C                   PARM                    OPAY              1
     C                   PARM                    CUSD              1
     C                   PARM                    AMAD              1
     C                   PARM                    IPAY              1
     C                   PARM                    SECS              1
     C                   PARM                    SECD              1
     C                   PARM                    SEDE              1
     C                   PARM                    SPTR              1
     C                   PARM                    BSRT              1
     C                   PARM                    FUND              1
     C                   PARM                    REPO              1
     C                   PARM                    BYSL              1
     C                   PARM                    YRAT              1
     C                   PARM                    ASGN              1
     C                   PARM                    RPRT              1
     C                   PARM                    FPRT              1
     C                   PARM                    FAMD              1
     C                   PARM                    FEAD              1
     C                   PARM                    FEST              1
     C                   PARM                    CACF              1
     C                   PARM                    MVTS              1                          CSE039
     C                   PARM                    TRSM              1                          CAP182
     C                   PARM                    STPR              1                          CSE040
     C                   PARM                    FCIP              1                          CAP073
     C                   PARM                    CLIP              1                          CAP074
     C                   PARM                    LOAM              1                          CAP075
     C                   PARM                    LERI              1                          CAP076
     C                   PARM                    MAPY              1                          CAP077
     C                   PARM                    FEEM              1                          CAP078
     C                   PARM                    RPSC              1                          CAP079
     C                   PARM                    DLFE                                         CAS009
     C                   PARM                    ACUD              1                          CGL032
     C                   PARM                    CCTX              1                          CGL032
     C                   PARM                    JACM              1                          CGL032
     C                   PARM                    NAHL              1                          CGL032
     C                   PARM                    NATX              1                          CGL032
     C                   PARM                    MPRI              1                          CAP183
     C/COPY WNCPYSRC,APH00016
     C                   PARM                    CUAH                                        CER034A
     C                   PARM                    DCMT              1                          CSD093
     C                   PARM                    ACRV              1                          CSD092
 
      * Call the first DBU submission program
 
     C                   CALLB     'APCENDDBU'
     C                   PARM                    SYSTEM
     C                   PARM                    LDNI
     C                   PARM                    DEAM
     C                   PARM                    NASP
     C                   PARM                    NASS
     C                   PARM                    FXDL
     C                   PARM                    FRA
     C                   PARM                    SIRS
     C                   PARM                    CIRS
     C                   PARM                    DPMV
     C                   PARM                    TRAD
     C                   PARM                    TRAN
     C                   PARM                    INTC
     C                   PARM                    FWRT
     C                   PARM                    INTR
     C                   PARM                    PRCS
     C                   PARM                    PFDM
     C                   PARM                    BITH
     C                   PARM                    BITP
     C                   PARM                    OPAY
     C                   PARM                    CUSD
     C                   PARM                    AMAD
     C                   PARM                    IPAY
     C                   PARM                    SECS
     C                   PARM                    SECD
     C                   PARM                    SEDE
     C                   PARM                    SPTR
     C                   PARM                    BSRT
     C                   PARM                    FUND
     C                   PARM                    REPO
     C                   PARM                    BYSL
     C                   PARM                    YRAT
     C                   PARM                    ASGN
     C                   PARM                    RPRT
     C                   PARM                    FPRT
     C                   PARM                    FAMD
     C                   PARM                    FEAD
     C                   PARM                    FEST
     C                   PARM                    CACF
     C                   PARM                    MVTS                                         CSE039
     C                   PARM                    DLFE                                         239136
     C/COPY WNCPYSRC,APH00017
     C                   PARM                    CUAH                                        CER034A
                                                                                              CAP182
      * Call the second DBU submission program                                                CAP182
                                                                                              CAP182
     C**********         CALLB     'APCENDDBU2'                                               CAP182
     C                   CALLB     'APCENDDBU3'                                        CAP182 CAP084
     C                   PARM                    SYSTEM                                       CAP182
     C                   PARM                    TRSM                                         CAP182
     C                   PARM                    STPR                                         CSE040
     C                   PARM                    FCIP                                         CAP073
     C                   PARM                    CLIP                                         CAP074
     C                   PARM                    LOAM                                         CAP075
     C                   PARM                    LERI                                         CAP076
     C                   PARM                    MAPY                                         CAP077
     C                   PARM                    FEEM                                         CAP078
     C                   PARM                    RPSC                                         CAP079
     C                   PARM                    ACUD                                         CGL032
     C                   PARM                    CCTX                                         CGL032
     C                   PARM                    JACM                                         CGL032
     C                   PARM                    NAHL                                         CGL032
     C                   PARM                    NATX                                         CGL032
     C                   PARM                    MPRI                                         CAP183
     C                   PARM                    DCMT                                         CSD093
     C                   PARM                    ACRV                                         CSD092
 
     C                   SETON                                        LR
     C                   RETURN
 
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
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
