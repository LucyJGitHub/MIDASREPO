     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Confirmation Message Extract Process')        *
      *****************************************************************
      *                                                               *
      *  Midas Dealing Module                                         *
      *                                                               *
      *  DL201356 - Midas DL Confirmation Message Extract Process     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CGL165             Date 17Feb15               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD022385           Date 16Sep13               *
      *                 MD022194           Date 04Sep13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD022385 - Sender to receiver information were misaligned    *
      *  MD022194 - MGOREFPD stops updating when trade repository ID  *
      *             is blank                                          *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
     F***DLRPIFPD  IF   E             DISK    INFSR(*PSSR)                                  MD022385
     FDLRPIFL5  IF   E           K DISK    INFSR(*PSSR)                                     MD022385
     F***CONEXCY   IF A E             DISK    INFSR(*PSSR)                                  MD022385
     FCONEXCY   IF A E           K DISK    INFSR(*PSSR)                                     MD022385
     FCONEXCZ   UF A E             DISK    INFSR(*PSSR)
     FDTRIXL8   IF   E             DISK    INFSR(*PSSR)
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
 
     D ERRORS          S              7
     D DLREFN          S              6
     D DLNUMB          S              6  0
     D PGMRUN          S              1
     D NOREC           S              5  0
     D KRPTI           S              1    INZ('Y')                                         MD022385
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Read all records in DLRPIFPD
 
     C**********         READ      DLRPIFPD                               99                MD022385
     C                   READ      DLRPIFL5                               99                MD022385
 
     C                   DOW       *IN99 = '0'
     C                   IF        RITRID <> *BLANKS                                        MD022194
 
     C                   EVAL      DLREFN = RITRRF
     C                   MOVE      DLREFN        DLNUMB
 
     C*****DLNUMB        CHAIN     CONEXCY                            98                    MD022385
     C     KCONEX        CHAIN     CONEXCY                            98                    MD022385
 
      ** If RICFRQ = 'Y' and If the entry does not exist in CONEXCY
 
     C                   IF        *IN98 = '1'
     C                              AND RICFRQ = 'Y'
 
     C     DLNUMB        CHAIN     DTRIXL8                            97
 
      ** If no records exist in DTRIXL8 (otherwise that means the
      ** output has been suppressed)
 
     C                   IF        *IN97 = '1'
 
     C     DLNUMB        CHAIN     DEALS                              95
      *
     C                   IF        *IN95 = '0'
     C                             AND RECI = 'D'
 
      ** Write a record in CONEXCY with RPTI = 'Y'
 
     C                   EVAL      RPTI = 'Y'
     C                   EVAL      RECI ='D'
     C                   EVAL      RCDT = 'D'
     C                   EVAL      DLNO = DLNUMB
     C                   EVAL      CNRQ = 'Y'
     C                   EVAL      CHTP = RICHTP
 
     C                   WRITE     CONEXCYF
 
      ** Add each record written in CONEXCY, in CONEXCZ
 
     C                   ADD       1             NOREC
 
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   ENDIF
     C                   ENDIF                                                              MD022194
 
     C**********         READ      DLRPIFPD                               99                MD022385
     C                   READ      DLRPIFL5                               99                MD022385
 
     C                   ENDDO
 
      ** Update NOREC in CONEXCZ
 
     C                   IF        NOREC > 0
 
     C     1             CHAIN     CONEXCZ                            96
 
     C                   IF        *IN96 = '1'
     C                   READ      CONEXCZ                                96
     C                   ENDIF
 
     C                   ADD       NOREC         NORE1
 
     C                   IF        *IN96 = '1'
 
     C                   WRITE     CONEXCZF
 
     C                   ELSE
 
     C                   UPDATE    CONEXCZF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD022385
      * *INZSR - Program Initialisation routine                       *                     MD022385
      *****************************************************************                     MD022385
                                                                                            MD022385
     C     *INZSR        BEGSR                                                              MD022385
                                                                                            MD022385
     C     KCONEX        KLIST                                                              MD022385
     C                   KFLD                    DLNUMB                                     MD022385
     C                   KFLD                    RICFRQ                                     MD022385
     C                   KFLD                    KRPTI                                      MD022385
                                                                                            MD022385
     C                   ENDSR                                                              MD022385
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        PGMRUN = ' '
     C                   EVAL      PGMRUN = 'Y'
     C                   END
 
     C                   SETON                                        U7U8LR
     C                   DUMP
 
     C                   ENDSR
