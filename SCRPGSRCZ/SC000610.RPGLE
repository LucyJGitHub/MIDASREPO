     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data replication controller')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000610 - Data Replication Controller                       *
      *                                                               *
      *  Function:  This module prepares the files to be used for     *
      *             RCVJRNE command.  Calls SC000620 as exit pgm of   *
      *             RCVJRNE command.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20         End of file for (SCFDTLL6)                      *
      *    21         LOOKUP on Arr_PF array                          *
      *    22         Error in calling QCMDEXC                        *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRSing - Single Batch Processing. ALL files processing        *
      * SRMultB - Multiple Batch Porcessing                           *
      * SRRcvJrn - Issue RCVJRNE command for selected files           *
      * SRChkDRS - Check SCDRSTAT                                     *
      * SRSetDly - Set the delay time                                 *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
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

      ** Data Replication File - Selected for Replication
     FSCFDTLL6  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** Data Replication Status data area
     D SCDRSTAT      E DS                  EXTNAME(SCDRSTAT) DTAARA(SCDRSTAT)

      ** SC24x7 Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** QCMDEXC data structures
     D WCommand1       DS           200
     D  WLib1                 13     14
     D  WCmd1                 53     62
     D  WJLIB1               155    156
     D  WJRcvRng1            162    171

     D WCommand2       DS          9000
     D  WLib2                 13     14
     D  WCmd2a                50   8749
     D  WCmd2b              8760   8769
     D  WJLIB2              8917   8918
     D  WJRcvRng2           8924   8933

      ** Command and PF data structures
     D WQcmd           S            100    DIM(7) CTDATA PERRCD(1)
     D Arr_PF          S             29    DIM(300)


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D P_BtchNo        S              1
     D P_JSeqN         S             10  0
     D P_JSeqA         S             10
     D PCMD            S           9000
     D PCMDLEN         S             15  5
     D PError          S              1
     D PLibrary        S             10
     D WBANK           S             29
     D X               S              3  0
     D Y               S              3  0
     D WFiller         S           8700
     D WDMLIB          S              7
     D WString16       S             16
     D WString29       S             29
     D WRUN            S              1
     D WCont           S              1
     D PRetCode        S             10

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   IF        DASBCH <> 'Y'
     C                   EXSR      SRMultB
     C                   ENDIF

     C                   DOW       WCont = *Blanks

      ** If Single Batch Processing

     C                   IF        DASBCH = 'Y'
     C                   EXSR      SRSing
     C                   ELSE
     C                   EXSR      SRRcvJrn
     C                   ENDIF

      ** Check if need to continue

     C                   EXSR      SRChkDRS

     C                   IF        WCont <> *Blanks
     C                   LEAVE
     C                   ENDIF

     C                   EXSR      SRSetDly

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSing - Single Batch Processing. Receive journal entry of    *
      *          all files.                                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************

     C     SRSing        BEGSR

     C                   EVAL      WCommand1 = WQcmd(1) + WQcmd(2)
     C                   EVAL      WLib1 = S1MAIN
     C                   EVAL      WCmd1 = P_JSeqA
     C                   EVAL      WJLIB1 = S1MAIN
     C                   EVAL      WJRcvRng1 = DARCVR
     C                   EVAL      PCMD = WCommand1
     C                   Z-ADD     172           PCMDLEN
     C                   CALL      'QCMDEXC'                            22
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN

     C                   IF        *IN22 = *ON
     C                   IF        PSExcpType = 'CPF' AND
     C                             (PSExcpNo = '7062' OR PSExcpNo = '7007' OR
     C                              PSExcpNo = '9803' OR PSExcpNo = '7054')
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'QCMDEXC'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMultB - Set up of array and override to file for            *
      *           multi-batch processing                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************

     C     SRMultB       BEGSR

     C                   EVAL      X = 0
     C                   CLEAR                   Arr_PF

     C     P_BtchNo      SETLL     SCFDTLL6
     C     P_BtchNo      READE     SCFDTLL6                               20
     C                   DOW       *IN20 = '0'

      ** Place all PF's in an array whose batch no. is same as the
      ** passed parameter to this pgm. "PF member should be *ALL"

     C                   EVAL      X = X+1
     C                   EXSR      SRBuildFile
     C                   EVAL      Arr_PF(X) = WString29

      ** No. of PF's loaded in array should not exceed 299

     C                   IF        X > 299
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'Arr_PF'
     C                   EVAL      DBKEY = FDPHYF
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     P_BtchNo      READE     SCFDTLL6                               20
     C                   ENDDO

      ** PF/SDBANKPD should be present as the last element in the array

     C                   EVAL      WDMLIB = S1MAIN + 'DMLIB'
     C                   EVAL      WBANK = '(' + WDMLIB + '/SDBANKPD   *ALL) '
     C     WBANK         LOOKUP    Arr_PF                                 21
     C                   IF        *IN21 = '0'
     C                   EVAL      Y = X+1
     C                   EVAL      Arr_PF(Y) = WBANK
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRcvJrn - Issue RCVJRNE of multiple files                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************

     C     SRRcvJrn      BEGSR

     C                   EVAL      WFiller = *BLANKS
     C                   EVAL      WCommand2 = %TRIMR(WQcmd(3)) +
     C                             WFiller + WQcmd(4) + WQcmd(5)
     C                   EVAL      WLib2 = S1MAIN
     C                   MOVEA     Arr_PF        WCmd2a
     C                   EVAL      WCmd2b = P_JSeqA
     C                   EVAL      WJLIB2 = S1MAIN
     C                   EVAL      WJRcvRng2 = DARCVR
     C                   EVAL      PCMD = WCommand2
     C                   Z-ADD     9000          PCMDLEN
     C                   CALL      'QCMDEXC'                            22
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN

     C                   IF        *IN22 = *ON
     C                   IF        PSExcpType = 'CPF' AND
     C                             (PSExcpNo = '7062' OR PSExcpNo = '7007' OR
     C                              PSExcpNo = '9803' OR PSExcpNo = '7054')
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFILE = 'QCMDEXC'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetDly - Set the delay time                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SC000500, QCMDEXC                                  *
      *                                                               *
      *****************************************************************

     C     SRSetDly      BEGSR

      ** Delay job for 1 minute

     C                   EVAL      PCMD = WQcmd(6)
     C                   Z-ADD     19            PCMDLEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCMD
     C                   PARM                    PCMDLEN

      ** Retrieve the last sequence no.

     C                   CALL      'SC000500'
     C                   PARM                    PRetCode
     C                   PARM                    P_BtchNo
     C                   PARM                    P_JSeqA

      ** Increment the Sequence number by 1

     C                   MOVE      P_JSeqA       P_JSeqN
     C                   EVAL      P_JSeqN = P_JSeqN + 1
     C                   MOVE      P_JSeqN       P_JSeqA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkDRS - Check SCDRSTAT                                     *
      *                                                               *
      * Called by: *INZSR and Main Processing                         *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     SRChkDRS      BEGSR

      ** Check SCDRSTAT

     C                   IN        SCDRSTAT

     C                   SELECT
     C                   WHEN      P_BtchNo = '0' or DASBCH = 'Y'
     C                   EVAL      WCont = DASTA0

     C                   WHEN      P_BtchNo = '1'
     C                   EVAL      WCont = DASTA1

     C                   WHEN      P_BtchNo = '2'
     C                   EVAL      WCont = DASTA2

     C                   WHEN      P_BtchNo = '3'
     C                   EVAL      WCont = DASTA3

     C                   WHEN      P_BtchNo = '4'
     C                   EVAL      WCont = DASTA4

     C                   WHEN      P_BtchNo = '5'
     C                   EVAL      WCont = DASTA5

     C                   WHEN      P_BtchNo = '6'
     C                   EVAL      WCont = DASTA6

     C                   WHEN      P_BtchNo = '7'
     C                   EVAL      WCont = DASTA7

     C                   WHEN      P_BtchNo = '8'
     C                   EVAL      WCont = DASTA8

     C                   WHEN      P_BtchNo = '9'
     C                   EVAL      WCont = DASTA9
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildFile - Build the library and file name                *
      *                                                               *
      *****************************************************************

     C     SRBuildFile   BEGSR

     C                   CALL      'ZACOBJLIB'
     C                   PARM                    FDPHYF
     C                   PARM                    PLibrary
     C                   PARM                    PError

     C                   IF        PError <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'ZACOBJLIB'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVEL     S1MAIN        PLibrary
     C                   EVAL      WString29 = '(' + PLibrary
     C     WString29     CAT       '/':0         WString29
     C                   EVAL      WString16 = FDPHYF + ' *ALL)'
     C     WString29     CAT       WString16:0   WString29

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
     C                   PARM                    P_JSeqA
     C                   PARM                    P_BtchNo

      ** Access SCDRSTAT

     C                   EXSR      SRChkDRS

      ** Access SC24X7

     C                   IN        SC24X7

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP

      ** Update Status in SCDRSTAT

     C     *LOCK         IN        SCDRSTAT

     C                   SELECT
     C                   WHEN      P_BtchNo = '0' or DASBCH = 'Y'
     C                   EVAL      DASTA0 = 'F'

     C                   WHEN      P_BtchNo = '1'
     C                   EVAL      DASTA1 = 'F'

     C                   WHEN      P_BtchNo = '2'
     C                   EVAL      DASTA2 = 'F'

     C                   WHEN      P_BtchNo = '3'
     C                   EVAL      DASTA3 = 'F'

     C                   WHEN      P_BtchNo = '4'
     C                   EVAL      DASTA4 = 'F'

     C                   WHEN      P_BtchNo = '5'
     C                   EVAL      DASTA5 = 'F'

     C                   WHEN      P_BtchNo = '6'
     C                   EVAL      DASTA6 = 'F'

     C                   WHEN      P_BtchNo = '7'
     C                   EVAL      DASTA7 = 'F'

     C                   WHEN      P_BtchNo = '8'
     C                   EVAL      DASTA8 = 'F'

     C                   WHEN      P_BtchNo = '9'
     C                   EVAL      DASTA9 = 'F'
     C                   ENDSL
     C                   OUT       SCDRSTAT

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** WQcmd
RCVJRNE JRN(  JLIB/ICJRN) EXITPGM(SC000620) FROMENT(          ) JRNCDE((R) (U) (F)) ENTTYP(UR UP UP
PT PX DL DR EG CR IZ JM MD RG XJ XE) DELAY(02) RCVRNG(  JLIB/          )
RCVJRNE JRN(  JLIB/ICJRN) EXITPGM(SC000620) FILE(
) FROMENT(          ) JRNCDE((R) (U) (F))
ENTTYP(UR UP PT PX DL DR EG CR IZ JM MD RG XJ XE) DELAY(02) RCVRNG(  JLIB/          )
DLYJOB DLY(60)
