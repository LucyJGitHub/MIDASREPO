     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM: Validate deal type')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVDLTYPE - Validate deal type                               *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             putative deal type, and confirms whether it is    *
      *             a valid Money Market type or not.  If it is valid *
      *             the 10A return code will be blank; if it is not,  *
      *             it will contain 'Error'                           *
      *             The module also requires a 4-alpha transaction    *
      *             type.  At present this can be LDNI, NASP, NASS    *
      *             or DEAM, for Loans and Deposits, Negotiable Assets*
      *             Purchased, Negotiable Assets Sold and Deal        *
      *             Amendments, respectively.                         *
      *                                                               *
      *             Note that only the basic validation is done: ie   *
      *             that the field is not blank, and is a legitimate  *
      *             deal type for the type of transaction.  For deal  *
      *             amendments, in particular, the more complex       *
      *             validation will have to be done in a module which *
      *             first calls this module.                          *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9827            Date 13Jan05               *
      *                 CDL033             Date 10Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG9827- CDL006 variable not imported                        *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Map variable names to indicators to allow use of names instead
      ** of numbers; base the following data structure on a pointer to
      ** the indicator array.
     D Indicators      DS                  BASED(pIndicator)
     D  LookUpOK              99     99
 
      ** Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
 
 
      ** Deal types for Loans, Deposits and Negotiable Assets Issued
     D***LDNI***         S              2A   DIM(9) CTDATA PERRCD(1)                          CDL033
     D LDNI            S              2A   DIM(10) CTDATA PERRCD(1)                           CDL033
 
      ** Deal types for Negotiable Assets Purchased
     D NASP            S              2A   DIM(7) CTDATA PERRCD(1)
 
      ** Deal types for Negotiable Assets Sold
     D NASS            S              2A   DIM(6) CTDATA PERRCD(1)
 
      ** Deal types for Deal Amendments
     D DEAM            S              2A   DIM(5) CTDATA PERRCD(1)
                                                                                CDL006
      ** Fiduciary deal types                                                   CDL006
     D FIDU            S              2A   DIM(6) CTDATA PERRCD(1)              CDL006
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Deal type (2A, from transaction)
     D DDType          S              2A
                                                                                CDL006
     D*******CDL006          S              1A   IMPORT                               CDL006 BUG9827
     D CDL006          S              1A                                                     BUG9827
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flag and mesage ID to prevent problems on
      ** subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   #MsgID
 
      **  Type must not be blank
     C     DDTYPE        IFEQ      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID= 'MMM0245'
 
      ** A different error message is used for Deal Amendments
     C                   IF        TransType = 'DEAM'
     C                   EVAL      #MsgID= 'MMM0297'
     C                   ENDIF
 
     C**  And it must exist on the relevant array for the transaction type
     C                   ELSE
 
     C                   SELECT
      **                 ------
 
     C                   WHEN      TransType = 'LDNI'
      **                 ----
     C     DDType        LOOKUP    LDNI                                   99
 
      ** If not an LDNI type, check if it's a FIDU type.                        CDL006
      ** And if deal is a fiduciary taking, amount of takings should            CDL006
      ** match amount of associated placing.                                    CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     LookUpOk      ANDEQ     False                                        CDL006
     C     DDType        LOOKUP    FIDU                                   99    CDL006
     C     LookUpOk      IFEQ      True                                         CDL006
     C     DDType        ANDEQ     'FT'                                         CDL006
     C     PActn         ANDEQ     'I'                                          CDL006
     C     LookUpOk      OREQ      True                                         CDL006
     C     DDType        ANDEQ     'DT'                                         CDL006
     C     PActn         ANDEQ     'I'                                          CDL006
     C     LookUpOk      OREQ      True                                         CDL006
     C     DDType        ANDEQ     'LT'                                         CDL006
     C     PActn         ANDEQ     'I'                                          CDL006
     C                   MOVE      'MMM9013'     PWMsgID1                       CDL006
     C                   ENDIF                                                  CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C                   IF        LookUpOK = False
     C                             OR (CDL033='N' AND DDType='CF')                            CDL033
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID = 'MMM0112'
     C                   ENDIF
 
     C                   WHEN      TransType = 'NASP'
      **                 ----
     C     DDType        LOOKUP    NASP                                   99
 
     C                   IF        LookUpOK = False
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID = 'MMM0109'
     C                   ENDIF
 
     C                   WHEN      TransType = 'NASS'
      **                 ----
     C     DDType        LOOKUP    NASS                                   99
 
     C                   IF        LookUpOK = False
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID = 'MMM0112'
     C                   ENDIF
 
     C                   WHEN      TransType = 'DEAM'
      **                 ----
     C     DDType        LOOKUP    DEAM                                   99
 
     C                   IF        LookUpOK = False
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID = 'MMM0298'
     C                   ENDIF
 
      ** If the transaction type was not one of those allowed, end in error
     C                   OTHER
      **                 -----
     C                   EXSR      *pssr
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    #MsgID
      ** Deal type (2A, from transaction)
     C                   PARM                    DDType
      ** Transaction type (4A, from caller)
     C                   PARM                    TransType
      ** Action code                                                            CDL006
     C                   PARM                    PActn             1            CDL006
      ** Floating Rate CDs Issued                                                             CDL033
     C                   PARM                    CDL033            1                          CDL033
      ** Warning message ID                                                     CDL006
     C                   PARM                    PWMsgID1          7            CDL006
      ** Fiduciary Deals
     C                   PARM                    CDL006                                      BUG9827
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** LDNI - Deal types for Loans, Deposits and NAs Issued
IT
IP
TD
TI
CI
LN
CD
CL
DL
CF                                                                                            CDL033
** NASP - Deal types for NAs Purchased
C1
C2
BP
BD
TB
DA
TA
** NASS - Deal types for NAs Sold
CS
BS
BR
TS
RA
TR
** DEAM - Deal types for Deal Amendments
SC
PI
PD
CI
SI
** FIDU - Deal types for fiduciary
FL
FT
DP
DT
LP
LT
