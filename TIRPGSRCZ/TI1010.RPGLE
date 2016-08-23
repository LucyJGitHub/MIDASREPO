     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Propogation support routine 30')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1010 - Midas SD Propogation Support Routine 30             *
      *                                                               *
      *  Function:  This program maps data between Midas and TI       *
      *  (phase(s))                                                   *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002             Date 070199                *
      *                 CTI001  *CREATE    Date 20OCT97               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *  CTI002 - Add Retail Account Functionality                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  STRUCT - Determine whether to call subroutine TI1000 or TI1005
      *  PROCES - Determine whether to call subroutine TI1002 or TI1007
      *  TI1000 - Calls mapping program TI1000                        *
      *  TI1001 - Calls mapping program TI1001                        *
      *  TI1002 - Calls mapping program TI1002                        *
      *  TI1003 - Calls mapping program TI1003                        *
      *  TI1004 - Calls mapping program TI1004                        *
      *  TI1005 - Calls mapping program TI1005                        *
      *  TI1006 - Calls mapping program TI1006                        *
      *  TI1007 - Calls mapping program TI1007                        *
      *  TI1008 - Calls mapping program TI1008                        *                       CTI002
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D SREC            DS
      ** Source record structure
     D  SRID                   1      2B 0
     D  SRNAME                 5     14
      *
     D TREC            DS
      ** Target record structure
     D  TRID                   1      2B 0
     D  TRNAME                 5     14
      *
     D SFLD            DS
      ** Source field structure
     D  SFNAME                 1     10
     D  SFTYPE                11     11
     D  SFPREC                12     13B 0
     D  SFSCAL                14     15B 0
      *
     D TFLD            DS
      ** Target field structure
     D  TFNAME                 1     10
     D  TFTYPE                11     11
     D  TFPREC                12     13B 0
     D  TFSCAL                14     15B 0
      *
     D SDATA           DS
      ** Source field data
     D  BBCSSN                 1     10
     D  BBCUST                 1      6
     D  BRCAX                  1      3
     D  A5TIAN                 4      9
     D  A5TIAS                10     12
     D**ACOD****               1      4  0                                                    CGL029
     D  ACOD                   1     10  0                                                    CGL029
     D  ATYP                   1      2
     D  MIDATE                 1      3P 0
     D  TICSID                 1     12
     D  TICBR9                 9     11
     D  A8BRCD                 1      3
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  BRCA                   1      3
     D  CCY                    1      3
     D  ACSQ                   1      2  0
      *
     D TDATA           DS
      ** Target field data
     D  GFCUS                  1      6
     D  GFCLC                  7      9
     D  CUSSTS                 1      1
     D  SCAI46                 1      1
     D  SCAI47                 1      1
     D  SCACT                  1      2
     D  TIDATE                 1      7  0
     D  TISABA                 1      4
     D  TISACO                 5      6
     D  TISALO                 7      8
     D  TISABR                 9     11
     D  A8TIBR                 1      4
     D**TIANO***               1      6  0                                                    CSD027
     D  TIANO                  1      6                                                       CSD027
     D  SCEAN1                 1     25
      * Amendments for CTI002                                                                 CTI002
     D  Retail_All             1     20                                                       CTI002
     D  Retail_1st             1     10                                                       CTI002
      *
     D EAN1            DS
     D  T_BRCA                 1      3
     D**T_CNUM**               4      9  0                                                    CSD027
     D  T_CNUM                 4      9                                                       CSD027
     D  T_CCY                 10     12
     D**T_ACOD**              13     16  0                                                    CGL029
     D**T_ACSQ**              17     18  0                                                    CGL029
     D**EAN1BL**              19     25                                                       CGL029
     D  T_ACOD                13     22  0                                                    CGL029
     D  T_ACSQ                23     24  0                                                    CGL029
     D  EAN1BL                25     25                                                       CGL029
      *
      /SPACE 3
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     *ENTRY        PLIST
     C                   PARM                    SREC
     C                   PARM                    SFLD
     C                   PARM                    SDATA
     C                   PARM                    SNEXT             1
     C                   PARM                    TREC
     C                   PARM                    TFLD
     C                   PARM                    TDATA
     C                   PARM                    ABORT             1
      *
     C                   MOVE      *BLANKS       ABORT
      *
      *
      ** Select program to call from Target Fields of type Strucure
      *
     C     TFTYPE        CASEQ     FSTRUC        STRUCT
     C     TFTYPE        CASEQ     FTAG          TAG
      *
      ** Select program to call from User Source Type
      *
     C     SFTYPE        CASEQ     MDATE         TI1004
     C     SFTYPE        CASEQ     DCHK          TI1001
     C     SFTYPE        CASEQ     INTACC        TI1003
     C     SFTYPE        CASEQ     ACCTYP        PROCES
     C     SFTYPE        CASEQ     BRANCH        TI1006
     C     SFTYPE        CASEQ     BOSQ          TBOSQ
     C     SFTYPE        CASEQ     RETAIL        TI1008                                       CTI002
     C                   ENDCS
      *
      ** Return to calling program
      *
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   STRUCT - Subroutine to decide whether to call subroutine    *
      *            TI1000 or TI1005                                   *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     TI1000                                            *
      *             TI1005                                            *
      *                                                               *
      ********************************************************************
     C     STRUCT        BEGSR
      *
      ** If Source Field Name is CUSCLC then call TI1000.
      ** Else If Source Field Name is SWIFT then call TI1005.
      *
     C     TFNAME        CASEQ     'CUSCLC'      TI1000
     C     TFNAME        CASEQ     'SWIFT'       TI1005
     C                   ENDCS
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TAG - Subroutine to store source fields for BOSQ type       *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     TBRCA                                             *
      *             TCNUM                                             *
      *             TCCY                                              *
      *             TACOD                                             *
      *                                                               *
      ********************************************************************
     C     TAG           BEGSR
      *
      ** If Source Field Name is CUSCLC then call TI1000.
      ** Else If Source Field Name is SWIFT then call TI1005.
      *
     C     TFNAME        CASEQ     'T_BRCA'      TBRCA
     C     TFNAME        CASEQ     'T_CNUM'      TCNUM
     C     TFNAME        CASEQ     'T_CCY'       TCCY
     C     TFNAME        CASEQ     'T_ACOD'      TACOD
     C                   ENDCS
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TBRCA Subroutine to store branch for BOSQ type              *
      *                                                               *
      *   Called by TAG                                               *
      *                                                               *
      ********************************************************************
     C     TBRCA         BEGSR
      *
     C                   MOVE      BRCA          T_BRCA
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TCNUM Subroutine to store customer for BOSQ type            *
      *                                                               *
      *   Called by TAG                                               *
      *                                                               *
      ********************************************************************
     C     TCNUM         BEGSR
      *
     C**********         Z-ADD     CNUM          T_CNUM                                       CSD027
     C                   EVAL      T_CNUM = CNUM                                              CSD027
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TCCY Subroutine to store currency for BOSQ type             *
      *                                                               *
      *   Called by TAG                                               *
      *                                                               *
      ********************************************************************
     C     TCCY          BEGSR
      *
     C                   MOVE      CCY           T_CCY
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TACOD Subroutine to store account code for BOSQ type        *
      *                                                               *
      *   Called by TAG                                               *
      *                                                               *
      ********************************************************************
     C     TACOD         BEGSR
      *
     C                   Z-ADD     ACOD          T_ACOD
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TBOSQ Subroutine to assemble back office account identifier *
      *                                                               *
      *   Called by Main processing                                   *
      *                                                               *
      ********************************************************************
     C     TBOSQ         BEGSR
      *
     C                   Z-ADD     ACSQ          T_ACSQ
     C                   MOVE      EAN1          SCEAN1
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   PROCES - Subroutine to decide whether to call subroutine    *
      *            TI1002 or TI1007                                   *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     TI1002                                            *
      *             TI1007                                            *
      *                                                               *
      ********************************************************************
     C     PROCES        BEGSR
      *
      ** If Target Field Name is SCACT then call TI1002.
      ** Else If Target Field Name is SCAI46 then call TI1007.
      *
     C     TFNAME        CASEQ     'SCAI46'      TI1002
     C     TFNAME        CASEQ     'SCACT'       TI1007
     C                   ENDCS
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1000 -  Midas TI Customer Mnemonic and Location Conversion*
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1000'                                  *
      *                                                               *
      ********************************************************************
     C     TI1000        BEGSR
     C                   CALL      'TI1000'
     C                   PARM                    BBCSSN
     C                   PARM                    GFCUS
     C                   PARM                    GFCLC
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1001 -  Midas TI Customer Status Conversion               *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1001'                                  *
      *                                                               *
      ********************************************************************
     C     TI1001        BEGSR
     C                   CALL      'TI1001'
     C                   PARM                    MIDATE
     C                   PARM                    CUSSTS
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1002 - Midas TI Contingent Account Conversion             *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1002'                                  *
      *                                                               *
      ********************************************************************
     C     TI1002        BEGSR
     C                   CALL      'TI1002'
     C                   PARM                    ACOD
     C                   PARM                    SCAI46
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1003 - Midas TI Internal Account Conversion               *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1003'                                  *
      *                                                               *
      ********************************************************************
     C     TI1003        BEGSR
      *
      ** If target not special condition 47 flag, then just move number
      *
     C     TFNAME        IFNE      'SCAI47'
     C**********         Z-ADD     CNUM          TIANO                                        CSD027
     C                   EVAL      TIANO = CNUM                                               CSD027
     C                   RETURN
     C                   ENDIF
      *
     C                   CALL      'TI1003'
     C                   PARM                    CNUM
     C                   PARM                    SCAI47
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1004 - Midas TI Date Coversion                            *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1004'                                  *
      *                                                               *
      ********************************************************************
     C     TI1004        BEGSR
     C                   CALL      'TI1004'
     C                   PARM                    MIDATE
     C                   PARM                    TIDATE
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1005 -  Midas TI SWIFT Address Conversion                 *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1005'                                  *
      *                                                               *
      ********************************************************************
     C     TI1005        BEGSR
     C                   MOVE      TICSID        TSID             12
     C     SFNAME        IFEQ      'BBCSID'
     C                   MOVE      TICBR9        TSID
     C                   ENDIF
     C                   CALL      'TI1005'
     C                   PARM                    TSID
     C                   PARM                    TISABA
     C                   PARM                    TISACO
     C                   PARM                    TISALO
     C                   PARM                    TISABR
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1006 -  Midas TI Branch Conversion                        *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1006'                                  *
      *                                                               *
      ********************************************************************
     C     TI1006        BEGSR
     C                   CALL      'TI1006'
     C                   PARM                    A8BRCD
     C                   PARM                    A8TIBR
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   TI1007 -  Midas TI Account Status Conversion                *
      *                                                               *
      *   Called by Main processing                                   *
      *   Calls     program 'TI1007'                                  *
      *                                                               *
      ********************************************************************
     C     TI1007        BEGSR
     C                   CALL      'TI1007'
     C                   PARM                    ACOD
     C                   PARM                    SCACT
     C                   ENDSR
      *****************************************************************                       CTI002
      *                                                               *                       CTI002
      *   TI1008 -  Midas TI Retail Account                           *                       CTI002
      *                                                               *                       CTI002
      *   Called by Main processing                                   *                       CTI002
      *   Calls     program 'TI1008'                                  *                       CTI002
      *                                                               *                       CTI002
      *****************************************************************                       CTI002
     C     TI1008        BEGSR                                                                CTI002
      *                                                               *                       CTI002
     C                   CALL      'TI1008'                                                   CTI002
     C                   PARM                    TFLD                                         CTI002
     C                   PARM                    SDATA                                        CTI002
     C                   PARM                    TDATA                                        CTI002
      *                                                               *                       CTI002
     C                   ENDSR                                                                CTI002
      ********************************************************************                    CTI002
      /EJECT                                                                                  CTI002
      ********************************************************************                    CTI002
      *                                                               *
      *   *INZSR - Define user type fields                            *
      *                                                               *
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVE      *ALLX'0D'     FTAG              1
     C                   MOVE      *ALLX'0E'     FSTRUC            1
      * User types
     C                   MOVE      *ALLX'14'     MDATE             1
     C                   MOVE      *ALLX'15'     DCHK              1
     C                   MOVE      *ALLX'16'     INTACC            1
     C                   MOVE      *ALLX'17'     ACCTYP            1
     C                   MOVE      *ALLX'18'     BRANCH            1
     C                   MOVE      *ALLX'19'     BOSQ              1
     C                   MOVE      *ALLX'1C'     RETAIL            1                          CTI002
      *
     C                   MOVE      *BLANKS       EAN1BL
     C                   ENDSR
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
