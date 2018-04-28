     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Block/Refer Debit/Credit fields Update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004600 - Block/Refer Debit/Credit fields Update            *
      *                                                               *
      *  Function:  This program is used to update Block Debit, Block *
      *             Credit, Refer Debit, Refer Credit fields when the *
      *             the Retail Account's Effective Date becomes less  *
      *             than or equal to rundate and greater than prev-   *
      *             ious rundate (JNSTAT).                            *
      *                                                               *
      *  Called By: SCC0411                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CRE075  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
 
      **  Accounts Master File
     FACCNTAB   UF   E           K DISK    INFSR(*PSSR)
      **
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Layout for data area JNSTAT
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
 
      ** Whether or not *PSSR has been run previously
     D WRun            S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        RUNDAT
     C                   IN        JNSTAT
     C                   Z-ADD     AGRDNB        CURDAT            5 0
     C                   Z-ADD     PRUN          PRVDAT            5 0
      *
      ** Update Block/Refer Debit/Credit for Retail Accounts
      *
     C                   EXSR      SRUPDATE
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATE - Update Block/Refer Debit/Credit for Retail Accts  *
      *                                                               *
      *****************************************************************
 
     C     SRUPDATE      BEGSR
      *
      ** Read records of Account Master file
      *
     C                   READ      ACCNTAB
 
     C                   DOW       NOT %EOF(ACCNTAB)
      *
      ** Process Retail account type only
      *
     C                   IF        ATYP = 'R'
 
     C                   IF        ACEFDT <= CURDAT AND
     C                             ACEFDT > PRVDAT
      *
      ** Refer Debits = 'N'
      *
     C                   BITOFF    '0'           RETB
      *
      ** Refer Credits = 'N'
      *
     C                   BITOFF    '1'           RETB
      *
      ** Block Debits = 'N'
     C                   BITOFF    '2'           RETB
      *
      ** Block Credits = 'N'
     C                   BITOFF    '3'           RETB
      *
      ** Update Accounts Master File
      *
     C                   UPDATE    ACCNTABF
 
     C                   ENDIF
     C                   ENDIF
     C                   READ      ACCNTAB
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Error control subroutine                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see if *PSSR has not already been called
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
