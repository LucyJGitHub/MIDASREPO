     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEMOD                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Append EODPOPD to APOSTPD')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0415 - Append EODPOPD to APOSTPD.                          *
      *                                                               *
      *  Function:  This program copies records from EODPOPD to       *
      *  APOSTPD if they have not already been included in Real       *
      *  Time Post.                                                   *
      *                                                               *
      *  Called By: GLC42                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL120             Date 06Aug12               *
      *  Prev Amend No. BUG27914           Date 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP203             Date 05Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU013             Date 29May98               *
      *                 122087 (111818)    Date 07Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL120 - GL COB Components Task Split                        *
      *         - Incorporate 261036A and CGL103                      *
      *  BUG27914 - RAME Design Changes                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CGL007 - Account Postings Enquiry. Recompile                 *
      *  CEU013 - EMU Account Posting Narrative. Recompile over       *
      *           changed APOSTPD.                                    *
      *  122087 - Created to replace inadequate CL Copy (111818).     *
      *                                                               *
      *****************************************************************
      /EJECT
     F**EODPOPD IF  E                    DISK                                                 CGL120
     FEODPOPD   IF   E             DISK    RECNO(WKRRN)                                       CGL120
     F                                     INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:EODPOPDF)
     FAPOSTPD   O    E             DISK
     F                                     COMMIT                                             CGL120
     FGLEODPPD  IF   E             DISK    INFSR(*PSSR)                                       CGL120
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     I***WAPOST*   E DSAPOSTPD                                                       CAP203 BUG27914
      ***APOSTPD*data*structure                                                      CAP203 BUG27914
     I***DSFDY**   E DSDSFDY                                                         CAP203 BUG27914
      ***Short*data*structure*for*access*programs*(200*long)                         CAP203 BUG27914
     I***SCSARD*   E DSSCSARDPD                                                      CAP203 BUG27914
      ***Switcable*Features*file                                                     CAP203 BUG27914
     I***DBERR**     DS                            256                               CAP203 BUG27914
     I**********                            134 141 DBFIL                            CAP203 BUG27914
     I**********                            142 170 DBKEY                            CAP203 BUG27914
     I**********                            171 180 DBPGM                            CAP203 BUG27914
     I**********                            181 1830DBASE                            CAP203 BUG27914
      *                                                                                       CGL120
     C                   Z-ADD     0             WKRRN             9 0                        CGL120
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   READ      GLEODPPD                               90                  CGL120
      **********                                                                     CAP203 BUG27914
      ***Access*SAR*details*file*to*determine*if*Retail*Account                      CAP203 BUG27914
      ***Transfer*is*switched*on                                                     CAP203 BUG27914
      **********                                                                     CAP203 BUG27914
     C**********           CALL 'AOSARDR0'                                           CAP203 BUG27914
     C**********           PARM *BLANKS   @RTCD   7                                  CAP203 BUG27914
     C**********           PARM '*VERIFY' @OPTN   7                                  CAP203 BUG27914
     C**********           PARM 'CAP203'  @SARD   6                                  CAP203 BUG27914
     C********** SCSARD    PARM SCSARD    DSFDY                                      CAP203 BUG27914
      **********                                                                     CAP203 BUG27914
     C**********           MOVEL'N'       CAP203  1                                  CAP203 BUG27914
     C********** @RTCD     IFEQ *BLANKS                                              CAP203 BUG27914
     C**********           MOVEL'Y'       CAP203                                     CAP203 BUG27914
     C**********           ELSE                                                      CAP203 BUG27914
     C********** @RTCD     IFNE '*NRF   '                                            CAP203 BUG27914
     C**********           Z-ADD001       DBASE                                      CAP203 BUG27914
     C**********           MOVEL'SCSARDPD'DBFIL                                      CAP203 BUG27914
     C**********           MOVEL'CAP203'  DBKEY                                      CAP203 BUG27914
     C**********           EXSR *PSSR                                                CAP203 BUG27914
     C**********           ENDIF                                                     CAP203 BUG27914
     C**********           ENDIF                                                     CAP203 BUG27914
      **********                                                                     CAP203 BUG27914
      *
      ** MAIN Processing.
     C     GLFERN        SETLL     EODPOPD                                                    CGL120
     C                   READ      EODPOPD                                80
      *
     C     *IN80         DOWEQ     '0'
     C     WKRRN         ANDLE     GLTERN                                                     CGL120
     C                   SETOFF                                       81
     C                   TESTB     '6'           PRIN                     81
      *
      ** If bit 6 is not set, the record is not a 'dummy' posting for
      ** Real Time Posting, so copy to APOSTPD.
     C     *IN81         IFEQ      '0'
     C                   WRITE     APOSTPDF
     C********** CAP203    IFEQ 'Y'                                                  CAP203 BUG27914
     C**********           CALL 'GP003006'                                           CAP203 BUG27914
     C**********           PARM 'I'       WMODE   1                                  CAP203 BUG27914
     C**********           PARM *BLANKS   WBRCA   3                                  CAP203 BUG27914
     C**********           PARM           WAPOST                                     CAP203 BUG27914
     C**********           ENDIF                                                     CAP203 BUG27914
     C                   END
      *
     C                   READ      EODPOPD                                80
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
