     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projections on-line extract')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPONLINE - Projections On-line Extract                      *
      *                                                               *
      *  Function:  This module receives journal images from the      *
      *             data export trigger file and calls the appropriate*
      *             extract module based on the transaction type      *
      *             within the tigger record.                         *
      *                                                               *
      *  Component of: DEPONLINE (program)                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. AR1004798          Date 30Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 20Aug02
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR1004798 - 10 long A/c code error                           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDETRIGL0  UF   E           K DISK    COMMIT INFSR(*PSSR)
     FDEOLEJPD  UF   E             DISK    COMMIT INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler03                     29A
      * Fields specific to the journal entry
     D***TransRef                     20A                                                     CGL029
     D***TransRef                     26A                                           CGL029 AR1004798
     D  QQTref                       20A                                                   AR1004798
     D  TransType                     4A
     D  ReservId                     10A                                        CDE005
     D  TransRef                     26A                                                   AR1004798
 
     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1
 
 
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
 
     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF
 
      * Remove the record from the extract trigger file if it exists,
      * else it should be completely ignored.
 
     C     TRIGKey       CHAIN     DETRIGL0                           99
 
     C     *IN99         IFEQ      '0'
     C                   DELETE    DETRIGL0
 
      * If the Transaction Reference contains a shut down message,
      *  tell the RCVJRNE command (and hence the controlling CL) to stop
 
     C                   IF        TransRef = 'SHUTDOWN'
     C                   EVAL      CTRLInfo1 = '9'
     C                   ELSE
 
      * Extract the transaction on the trigger entry
 
     C                   EXSR      EXTRACT
 
     C                   ENDIF
     C                   ENDIF
 
      * Store the sequence number used
 
     C     1             CHAIN     DEOLEJPD                           9999
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   UPDATE    DEOLEJP0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON CHAIN TO DEOLEJPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Commit the updates
 
     C                   COMMIT
 
     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Extract transactions
      *********************************************************************
     C     EXTRACT       BEGSR
 
     C                   MOVEL     *BLANK        Ret_Code
     C                   MOVEL     *BLANK        Err_Mess
     C                   MOVEL     *BLANK        ExtType
     C                   MOVEL     'Y'           EndofBook
 
     C                   SELECT
 
      * Extract for accounts
 
     C     TransType     WHENEQ    'ACCT'
     C                   CALL      'DEPXCACCT'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCACCT'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for cap/floor/collar options
 
     C     TransType     WHENEQ    'CFCO'
     C                   CALL      'DEPXCCFCO'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCCFCO'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for FRAs
 
     C     TransType     WHENEQ    'FRAS'
     C                   CALL      'DEPXCFRAS'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCFRAS'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for FX deals
 
     C     TransType     WHENEQ    'FXDL'
     C                   CALL      'DEPXCFXDL'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCFXDL'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for MM loans & deposits
 
     C     TransType     WHENEQ    'LDNI'
     C                   CALL      'DEPXCLDNI'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCLDNI'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for customer (lending) loans
 
     C     TransType     WHENEQ    'LOAN'
     C                   CALL      'DEPXCLOAN'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCLOAN'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for NAs purchased
 
     C     TransType     WHENEQ    'NASP'
     C                   CALL      'DEPXCNASP'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCNASP'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for (F&O) OTC options
 
     C     TransType     WHENEQ    'OTCC'
     C                   CALL      'DEPXCOTCC'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCOTCC'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for securities book positions
 
     C     TransType     WHENEQ    'SBPS'
     C                   CALL      'DEPXCSBPS'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCSBPS'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for securities trades
 
     C     TransType     WHENEQ    'STRD'
     C                   CALL      'DEPXCSTRD'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCSTRD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
      * Extract for interest rate swaps
 
     C     TransType     WHENEQ    'SWAP'
     C                   CALL      'DEPXCSWAP'   Exc_Parm
      *
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPXCSWAP'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSL
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
     C     Exc_Parm      PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    ExtType           4
     C                   PARM                    EndofBook         1
     C**********         PARM                    TransRef         20                          CGL029
     C                   PARM                    TransRef                                     CGL029
     C                   PARM                    ReservId         10            CDE005
 
     C     TRIGkey       KLIST
     C                   KFLD                    TransType
     C                   KFLD                    TransRef
     C                   KFLD                    ReservId                       CDE005
 
     C     *LIKE         DEFINE    Ret_Code      I#RTCD
     C     *LIKE         DEFINE    Err_Mess      I#ERMS
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
