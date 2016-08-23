     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate profit centre')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAVPROFITC - Validate profit centre                          *
      *                                                               *
      *  Function:  This module checks that a supplied profit centre  *
      *             is indeed a valid profit centre on the system.    *
      *             If the profit centre field is blank, and default  *
      *             profit centres are used, it will return the       *
      *             appropriate default profit centre in the          *
      *             parameter field                                   *
      *                                                               *
      *  Component of: ZAVALIDATE - ZA validation modules             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. 179732             Date 26Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  179732 - Only allocate PRFC if Customer is valid.            *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      ** EXTERNAL DS FOR PROFIT CENTRES
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID
     D @MSGID          S                   LIKE(#Msgid)
 
      ** Profit Centre
     D DDPRFC          S              4A
 
      ** Profit centres used flag
     D BKPRCU          S              1A
 
      ** Profit centres amendable
     D BKPRCA          S              1A
 
      ** Profit centre defaults used
     D BKPCDU          S              1A
 
      ** Deal Type
     D DDTYPE          S              2A
 
      ** Account officer code
     D BBACOC          S              2A
 
      ** Customer
     D BBCUST          S              6A
 
      ** Book code
     D DDBOKC          S              2A
 
      ** Deal subtype
     D DDSTYP          S              2A
 
      ** Branch code
     D DDBRCA          S              3A
 
      ** Department code
     D DEPT            S              3A
 
      ** User
     D @USER           S             10A
 
      ** Customer OK flag
     D CustOK          S              1A
 
      ** Profit Centre Accounting installed
     D BGN0ST          S              1A
 
      ** End of parameters
      ** =================
 
      ** Transaction type
     D TRTP            S              5A
 
      ** Book code
     D BOOK            S                   LIKE(DDBOKC)
 
      ** Deal subtype
     D SUTP            S                   LIKE(DDSTYP)
 
      ** Branch code
     D BRAN            S                   LIKE(DDBRCA)
 
      ** Department code
     D DEPT1           S                   LIKE(DEPT)
 
      ** User
     D USER            S                   LIKE(@USER)
 
      ** Profit centre
     D @WKPR           S                   LIKE(DDPRFC)
 
      ** Return Code from AOPRFMR0
     D RetCode1A       S              1A
 
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
 
      ** Reset error found flag to prevent problems on later calls
     C                   RESET                   ErrorFound
 
      ** Only validate if profit centres are used
     C     BKPRCU        IFEQ      'Y'
 
      ** If profit centre is not entered and profit centre defaults are
      ** used, get the default profit centre from the file
      *  And if the customer is not in error.                                               179732
     C     DDPRFC        IFEQ      *BLANKS
     C     BKPCDU        ANDEQ     'Y'
     C     CustOK        ANDEQ     'Y'                                                      179732
      *
      ** MUST SET UP SOME FIELDS
     C                   CLEAR                   TRTP
     C                   MOVEL     DDTYPE        TRTP              5
     C*
     C****If*customer*in*error*ensure*account*officer*parameter*is                          179732
     C****blank.**************************************************                          179732
     C****************** IF        CustOK = 'N'                                             179732
     C****************** MOVE      *BLANKS       ACOF                                       179732
     C****************** ELSE                                                               179732
     C****************** MOVE      BBACOC        ACOF                                       179732
     C****************** MOVE      BBCUST        CUST                                       179732
     C****************** ENDIF                                                              179732
     C*                                                                                     179732
     C                   MOVE      BBACOC        ACOF                                       179732
     C                   MOVE      BBCUST        CUST                                       179732
     C*
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       RetCode1A
     C                   PARM      DDBOKC        BOOK              2            Book Code
     C                   PARM                    TRTP              5            Transacton Type
     C                   PARM      DDSTYP        SUTP              2            Sub Type
     C                   PARM      DDBRCA        BRAN              3            Branch Code
     C                   PARM      DEPT          DEPT1             3            Deptment Code
     C                   PARM      @USER         USER             10            User
     C                   PARM                    ACOF              2            Account Officer
     C                   PARM                    CUST              6            Customer Number
     C     DDPRFC        PARM                    PRFC              4            Profit CentrE
      *
     C     RetCode1A     IFEQ      '2'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM4001'     @MSGID
     C                   GOTO      #ZI9
     C                   END
      *
     C                   END
 
     C     DDPRFC        IFNE      *BLANKS
     C     BGN0ST        OREQ      'Y'
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDPRFC        @WKPR             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM4001'     @MSGID
     C                   GOTO      #ZI9
     C                   ELSE
     C                   MOVEL     DSPCCD        DDPRFC
     C                   END
     C                   END
      *
     C                   END
 
     C     #ZI9          TAG
 
      ** Set return code
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
     C                   PARM                    RetCodeIn
     C                   PARM                    @MSGID
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDTYPE
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    DDBRCA
     C                   PARM                    DEPT
     C                   PARM                    @USER
     C                   PARM                    CustOK
     C                   PARM                    BGN0ST
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
