     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Access Global Transtns, Accts and Positns')   *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  GPAOTRAPR0 - Midas Access Global Transactions, Accounts      *
      *               and Positions                                   *
      *                                                               *
      *  Function: This module accesses the global transactions,      *
      *            accounts and positions                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit    - Initialisation                                    *
      * SRProcess - Main processing                                   *
      * *PSSR     - Error processing                                  *
      *                                                               *
      *****************************************************************
 
      ** Midas GP Joined File for GPTRAPPD and GPCASHPD
 
     FGPTRAPJ2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
 
      ** Program status data structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DS for Midas Global Transactions, Accounts and Positns
 
     D GPTRAP        E DS                  EXTNAME(GPTRAPPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1    INZ(' ')
     D WOpen           S              1    INZ(' ')
     D Buffer          S           4000A
 
      ** Parameters
 
     D PReturncode     S              7A
     D POption         S              7A
     D PZone           S             10A
     D PSubModule      S              4A
     D PTransRef6A     S              6A
     D P_Date          S                   LIKE(C_DATE)
     D P_IO            S                   LIKE(C_IO)
     D P_Amnt          S                   LIKE(C_AMNT)
 
      ** Key fields
 
     D KZone           S                   LIKE(T_ZONE)
     D KSubModule      S                   LIKE(T_SMOD)
     D KTransRef6A     S                   LIKE(T_TR6A)
 
      *****************************************************************
      *  Main Procedure                                               *
      *****************************************************************
 
     C                   EXSR      SRINIT
     C                   EXSR      SRPROCESS
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturncode
     C                   PARM                    POption
     C                   PARM                    PZone
     C                   PARM                    PSubModule
     C                   PARM                    PTransRef6A
 
      ** Outputs
 
     C                   PARM                    P_Date
     C                   PARM                    P_IO
     C                   PARM                    P_Amnt
 
      ** Key lists
 
     C     K@TRAPJ2      KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KSubModule
     C                   KFLD                    KTransRef6A
 
 
      ** Clear return code
 
     C                   EVAL      PReturncode = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Access Global Retail Account Movements Details   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Open files once
 
     C                   IF        WOpen  <> 'Y'
     C                   OPEN      GPTRAPJ2
     C                   EVAL      WOpen  = 'Y'
     C                   ENDIF
 
     C                   EVAL      KZone       =  PZone
     C                   EVAL      KSubModule  =  PSubModule
     C                   EVAL      KTransRef6A =  PTransRef6A
 
      ** Use Option if passed
 
     C                   SELECT
 
     C                   WHEN      POption     = '*KEY   '
 
     C     K@TRAPJ2      CHAIN     GPTRAPJ2
 
     C                   IF        NOT %FOUND(GPTRAPJ2)
     C                   EVAL      PReturncode = '*NOREC'
     C                   ENDIF
 
      ** Caller requests first record :
 
     C                   WHEN      POption = '*FIRST '
 
     C     K@TRAPJ2      SETLL     GPTRAPJ2
     C                   EVAL      POption = '*NEXT  '
 
      ** Caller requests next record :
 
     C                   WHEN      POption = '*NEXT  '
 
     C     K@TRAPJ2      READE     GPTRAPJ2
     C                   IF        %EOF(GPTRAPJ2)
     C                   EVAL      PReturncode = '*EOF'
     C                   ENDIF
 
     C                   ENDSL
 
      ** Return detail record if found
 
     C                   IF        PReturncode = '*EOF' OR
     C                             PReturncode = '*NOREC'
     C                   EVAL      P_Date = 0
     C                   EVAL      P_IO   = *BLANKS
     C                   EVAL      P_Amnt = 0
     C                   ELSE
     C                   EVAL      P_Date = C_DATE
     C                   EVAL      P_IO   = C_IO
     C                   EVAL      P_Amnt = C_AMNT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   EVAL      Buffer = 'UNEXPECTED ERROR'
     C                   CALL      'GPWRTELOG'
     C                   PARM                    Buffer
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
