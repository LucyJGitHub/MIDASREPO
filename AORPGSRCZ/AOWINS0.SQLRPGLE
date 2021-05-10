     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas AO to determine if a window exists')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS PROGRAMS
     F*                                                                  *
     F*     AOWINS0  - DETERMINE IF A WINDOW PROGRAM EXISTS              *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD057705           Date 21Jan21               *
      *  Prev Amend No. MD056890           Date 11Oct20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                     BHF270           Date 19Mar05             *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *      MD057705 - Deliverable Data Split for SDOREFPD              *
      *      MD056890 - Deliverable Data Split for SDMREFPD              *
      *      MD055681 - Deliverable Data Split for SAR                   *
      *      MD046248 - Finastra Rebranding                              *
      *      CPK018 - Change to make windows switchable. Replace use of  *
      *               - Replace use of SDMREFL1 with SDMREFJ0.           *
      *      BHF270 -  CHANGE THE FORMAT NAME FOR SDOREFL1               *
     F*                                                                  *
     F********************************************************************
     F*
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       95       NO RECORD FOUND - Window Program Does Not Exist
     F*
      /EJECT
     F*FSTART
      ************************************************************
     F*SDMREFL1IF*E*****      K        DISK                                                   CPK018
     F*SDMREFJ0* IF   E           K DISK                                                    MD056890
      * IN  - @DLREGT Mandatory Window
      ************************************************************
     F*SDOREFL1* IF   E           K DISK    USROPN                                          MD057705
      * IN  - @DNREGZ Optional Window
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arr
     D SDMREF        E DS                  EXTNAME(SDMRFJW1)                                MD056890
     D NullInds        s              5i 0 dim(17)                                          MD056890
     D SDOREF        E DS                  EXTNAME(SDOREJW0)                                MD057705
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     P@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@PGM            10            I:Program Name
     C*****************************************************
     C*
     C*MAIN
     C*
     C**Chain*to*SDMREFL1*for*Window*Record***************                                    CPK018
     C* Chain to SDMREFJ0 for Window Record                                                   CPK018
     C*
     C********** P@PGM     CHAIN@DLREGT              9590    Get record                       CPK018
     C*****P@PGM         CHAIN     @MREFJ0                            9590        Get recordMD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF :NullInds                                                              MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :P@PGM                                                               MD056890
     C/END-EXEC                                                                             MD056890
     C                   Setoff                                       9095                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   SETON                                        95                    MD056890
     C                   ENDIF                                                              MD056890
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD056890
     C                   SETON                                        90                    MD056890
     C                   ENDIF                                                              MD056890
                                                                                            MD056890
     C     *IN90         CABEQ     '1'           T@SKIP                           File error
     C     *IN95         IFEQ      '1'                                            No record found
     C*
     C**Open*File*SDOREFL1*if*a*record*was*not*found*in*SDMREFL1**********                    CPK018
     C* Open File SDOREFL1 if a record was not found in SDMREFJ0                              CPK018
     C*
     C***********        OPEN      SDOREFL1                             91        Open  fileMD057705
     C******IN91         CABEQ     '1'           T@SKIP                           Open  erroMD057705
     C*
     C* Chain to SDOREFL1 for a window record
     C*
     C***********P@PGM*****CHAIN@DNREGZ              9590    Get record   BHF270
     C*****P@PGM         CHAIN     @DMREGW                            9590        Get BHF27 MD057705
     C/EXEC SQL                                                                             MD057705
     C+ SELECT *                                                                            MD057705
     C+ into :SDOREF                                                                        MD057705
     C+ from SDOREJW0                                                                       MD057705
     C+ where DMNMCP = :P@PGM                                                               MD057705
     C/END-EXEC                                                                             MD057705
     C                   Setoff                                       9095                  MD057705
     C                   If        SQLCODE = 100                                            MD057705
     C                   SETON                                        95                    MD057705
     C                   ENDIF                                                              MD057705
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD057705
     C                   SETON                                        90                    MD057705
     C                   ENDIF                                                              MD057705
                                                                                            MD057705
     C     *IN90         CABEQ     '1'           T@SKIP                           File error
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C*
     C* Close File SDOREFL1
     C*
     C**********         CLOSE     SDOREFL1                             92        Close fileMD057705
     C******IN92         CABEQ     '1'           T@SKIP                           Close erroMD057705
     C*
     C                   END
      *
      * Return appropriate error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C***91*****         MOVE      '*OPEN  '     P@RTCD                         Open error  MD057705
     C***92*****         MOVE      '*CLOSE '     P@RTCD                         Close error MD057705
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
      *
      * Return to caller :
      *
     C                   SETON                                        LR          Set ind.
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA CPY@
(c) Finastra International Limited 2001
