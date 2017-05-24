     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Referral/Excess Report Extr-Copy Records')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3760T2 - Midas RE Referral and Excess Report Extract       *
      *             Task Split Copy Records                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD044973           Date 22May17               *
      *  Prev Amend No. MD034384A          Date 08Dec15               *
      *                 MD034384           Date 27Nov15               *
      *                 MD022097           Date 30Aug13               *
      *                 CRE083BU *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044973 - Undefined record type. Recompile to re-deliver    *
      *             source with MD034384A fix.                        *
      *  MD034384A - Reversed MD034384 fix as it is not applicable    *
      *              for core especially if feature CGL002 is         *
      *              switched Off                                     *
      *  MD034384 - REC3760T2/00001 - Undefined record type           *
      *  MD022097 - Low performance of REC3760T2                      *
      *  CRE083BU - COB Restructure - RE COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************

     F***GLRACCL1  IF   E           K DISK    INFSR(*PSSR)                                  MD022097
     F***SSRACJL   IF   E           K DISK    INFSR(*PSSR)                         MD022097 MD034384
     F***GLACCTJ0  IF   E           K DISK    INFSR(*PSSR)                        MD034384 MD034384A
     FSSRACJL   IF   E           K DISK    INFSR(*PSSR)                                    MD034384A

     FRERACDPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SSRACJF:DRIVERF)
     F                                     COMMIT
     F                                     USROPN

     FRERACIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SSRACJF:INDEXF)
     F                                     COMMIT
     F                                     PREFIX(I_)

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D inPssr                          N
     D TOT             S              7  0

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *                                                               *
      * Calls: TSPLIT, END                                            *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3

     C     AKEY          KLIST
     C**********         KFLD                    I_BRCA                                     MD022097
     C**********         KFLD                    I_CNUM                                     MD022097
     C**********         KFLD                    I_CCY                                      MD022097
     C**********         KFLD                    I_ACOD                                     MD022097
     C**********         KFLD                    I_ACSQ                                     MD022097
     C                   KFLD                    I_SBRCA                                    MD022097
     C                   KFLD                    I_SCNUM                                    MD022097
     C                   KFLD                    I_SCCY                                     MD022097
     C                   KFLD                    I_SACOD                                    MD022097
     C                   KFLD                    I_SACSQ                                    MD022097

     C                   OPEN      RERACDPD

      ** Split records into new file

     C                   EXSR      TSPLIT

      ** End processing

     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * TSPLIT - Split records into new driver and index files        *
      *                                                               *
      * Called by: Main Processing                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     TSPLIT        BEGSR

      ** Read the index file to determine start position on master file

     C     *START        SETLL     RERACIPD
     C                   READ      RERACIPD
     C                   IF        %EOF(RERACIPD)
     C******LOVAL        SETLL     GLRACCL1                                                 MD022097
     C******LOVAL        SETLL     SSRACJL                                         MD022097 MD034384
     C******LOVAL        SETLL     GLACCTJ0                                       MD034384 MD034384A
     C     *LOVAL        SETLL     SSRACJL                                                 MD034384A
     C                   ELSE
     C*****AKEY*         SETGT     GLRACCL1                                                 MD022097
     C*****AKEY          SETGT     SSRACJL                                         MD022097 MD034384
     C*****AKEY          SETGT     GLACCTJ0                                       MD034384 MD034348A
     C     AKEY          SETGT     SSRACJL                                                 MD034384A
     C                   ENDIF

      ** Copy records to the new driver file until the limit
      ** specified in the input parameter (RECTOT) is reached.

     C                   EVAL      TOT = 0
     C**********         DOU       %EOF(GLRACCL1) or TOT = RECTOT                           MD022097
     C**********         READ      GLRACCL1                                                 MD022097
     C**********         IF        NOT %EOF(GLRACCL1)                                       MD022097
     C**********         DOU       %EOF(SSRACJL) or TOT = RECTOT                   MD022097 MD034384
     C**********         READ      SSRACJL                                         MD022097 MD034384
     C**********         IF        NOT %EOF(SSRACJL)                               MD022097 MD034384
     C**********         DOU       %EOF(GLACCTJ0) or TOT = RECTOT                 MD034384 MD034384A
     C**********         READ      GLACCTJ0                                       MD034384 MD034384A
     C**********         IF        NOT %EOF(GLACCTJ0  )                           MD034384 MD034384A
     C                   DOU       %EOF(SSRACJL) or TOT = RECTOT                           MD034384A
     C                   READ      SSRACJL                                                 MD034384A
     C                   IF        NOT %EOF(SSRACJL)                                       MD034384A
                                                                                            MD022097
      ** Set the 'S' fields of driver file with data                                        MD022097
      ** from the first record read                                                         MD022097
                                                                                            MD022097
     C                   IF        TOT = 0                                                  MD022097
     C                   EVAL      SBRCA = BRCA                                             MD022097
     C                   EVAL      SCNUM = CNUM                                             MD022097
     C                   EVAL      SCCY  = CCY                                              MD022097
     C                   EVAL      SACOD = ACOD                                             MD022097
     C                   EVAL      SACSQ = ACSQ                                             MD022097
     C                   ENDIF                                                              MD022097
                                                                                            MD022097
     C**********         WRITE     DRIVERF                                                  MD022097
     C                   EVAL      TOT = TOT + 1
     C                   ENDIF
     C                   ENDDO

      ** Set the 'E' fields of driver file with the last record read                        MD022097
      ** Then, output record to the driver file                                             MD022097
                                                                                            MD022097
     C                   IF        TOT > 0                                                  MD022097
     C                   EVAL      EBRCA = BRCA                                             MD022097
     C                   EVAL      ECNUM = CNUM                                             MD022097
     C                   EVAL      ECCY  = CCY                                              MD022097
     C                   EVAL      EACOD = ACOD                                             MD022097
     C                   EVAL      EACSQ = ACSQ                                             MD022097
     C                   WRITE     DRIVERF                                                  MD022097
     C                   ENDIF                                                              MD022097
      *****************************************************************                     MD022097
      ***Update*(or*write*to)*index*file*to*reflect*the*last***********                     MD022097
      ***record*processed**********************************************                     MD022097
      *****************************************************************                     MD022097
     C**********         EVAL      I_RECI = RECI                                            MD022097
     C**********         EVAL      I_BRCA = BRCA                                            MD022097
     C**********         EVAL      I_ATYP = ATYP                                            MD022097
     C**********         EVAL      I_STYP = STYP                                            MD022097
     C**********         EVAL      I_CNUM = CNUM                                            MD022097
     C**********         EVAL      I_CCY = CCY                                              MD022097
     C**********         EVAL      I_ACOD = ACOD                                            MD022097
     C**********         EVAL      I_ACSQ = ACSQ                                            MD022097
     C**********         EVAL      I_ACNO = ACNO                                            MD022097
     C**********         EVAL      I_CASK = CASK                                            MD022097
     C**********         EVAL      I_CRNM = CRNM                                            MD022097
     C**********         EVAL      I_ACOC = ACOC                                            MD022097
     C**********         EVAL      I_EFAC = EFAC                                            MD022097
     C**********         EVAL      I_RETB = RETB                                            MD022097
     C**********         EVAL      I_LRCR = LRCR                                            MD022097
     C**********         EVAL      I_LDBL = LDBL                                            MD022097
     C**********         EVAL      I_CLBL = CLBL                                            MD022097
     C**********         EVAL      I_HELD = HELD                                            MD022097
     C**********         EVAL      I_MINB = MINB                                            MD022097
     C**********         EVAL      I_ODLN = ODLN                                            MD022097
     C**********         EVAL      I_ODED = ODED                                            MD022097
     C**********         EVAL      I_DLIM = DLIM                                            MD022097
     C**********         EVAL      I_EPGB = EPGB                                            MD022097
     C**********         EVAL      I_EPNB = EPNB                                            MD022097
     C**********         EVAL      I_RTLB = RTLB                                            MD022097
     C**********         EVAL      I_RTCB = RTCB                                            MD022097
     C**********         EVAL      I_STFQ = STFQ                                            MD022097
     C**********         EVAL      I_DACO = DACO                                            MD022097

      ** Set the 'S' fields of index file with data                                         MD022097
      ** from the last record read                                                          MD022097
                                                                                            MD022097
     C                   EVAL      I_SBRCA = BRCA                                           MD022097
     C                   EVAL      I_SCNUM = CNUM                                           MD022097
     C                   EVAL      I_SCCY  = CCY                                            MD022097
     C                   EVAL      I_SACOD = ACOD                                           MD022097
     C                   EVAL      I_SACSQ = ACSQ                                           MD022097
     C                   EVAL      I_EBRCA = *BLANKS                                        MD022097
     C                   EVAL      I_ECNUM = *BLANKS                                        MD022097
     C                   EVAL      I_ECCY  = *BLANKS                                        MD022097
     C                   EVAL      I_EACOD = 0                                              MD022097
     C                   EVAL      I_EACSQ = 0                                              MD022097
                                                                                            MD022097
      ** If Index file is empty write new record to it,else update
      ** with details of last record procesed

     C                   IF        %EOF(RERACIPD)
     C                   WRITE     INDEXF
     C                   ELSE
     C                   UPDATE    INDEXF
     C                   ENDIF

     C                   COMMIT
     C                   CLOSE     RERACDPD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - Exit program and return to calling program.             *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     END           BEGSR

      ** If end of file, set return code to notify server

     C**********         IF        %EOF(GLRACCL1)                                           MD022097
     C**********         IF        %EOF(SSRACJL)                                   MD022097 MD034384
     C**********         IF        %EOF(GLACCTJ0 )                                MD034384 MD034384A
     C                   IF        %EOF(SSRACJL)                                           MD034384A
     C                   IF        TOT = 0
     C                   EVAL      RTCODE = 'NRF'
     C                   ELSE
     C                   EVAL      RTCODE = 'EOF'
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        NOT inPssr
     C                   DUMP
     C                   EVAL      inPssr = *ON
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN

     C                   ENDSR
