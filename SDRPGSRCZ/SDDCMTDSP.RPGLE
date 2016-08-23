     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Detail screen')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTDSP  - Document Management Display Detail              *
      *                                                               *
      *  Function:  This module displays details screen of the        *
      *             Document Management                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDDCMTDSDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-26 Field Error - highlight screen fields               *
      *       60  Change from Customer to Non-Account Holder headers  *
      *       68  Position cursor on first screen field if no errors  *
      *       69  Protect recd key fields                             *
      *       70  Protect screen fields                               *
      *       72  Enable function key F10 (delete)                    *
      *       73  Enable function key F23 (further details)           *
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrZ0           S              1    DIM(60) CTDATA PERRCD(60)
 
     D ArrEI           S              1    DIM(60)
 
      ** Document Management Screen Details
     D DocMgtScn     E DS                  EXTNAME(SDDCMSPD)
 
      ** Document Management OK Flag Details
     D OKFlagsDS     E DS                  EXTNAME(SDEDCMTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CLRSCRN         S              1
     D PEKYFD          S              1
     D PEDTFD          S              1
     D PEINKJ          S              1
     D PEINKV          S              1
     D PINKC           S              1
     D PINKJ           S              1
     D PINKL           S              1
     D PINKV           S              1
     D ISDAFlag        S              1
     D PHDTFD          S              1
     D PINTYP          S              1
     D PINMOD          S              1
     D PRTCD           S              7
     D POPTN           S              7
     D WCount          S              2P 0
     D WErr            S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
 
     C                   IF        PINKL = '1'
     C                   EVAL      CLRSCRN = 'Y'
     C                   ELSE
     C                   EVAL      CLRSCRN = 'N'
     C                   ENDIF
      *
      ** Return
      *
     C                   IF        PINKC = '1'
     C                   SETON                                        LR
     C                   END
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Move 'OK' Flags Into Array (For Checking)
      *
     C                   MOVEA     OKFlagsDs     ArrEI
      *
      ** Set Screen Error Indicators According to STATUS of 'OK' Flags
      *
     C                   EVAL      WCount = 1
     C                   EVAL      WErr = 10
 
     C                   DOU       WCount > 16
     C                   IF        ArrEI(WCount) = 'N'
     C                             OR ArrEI(WCount) = 'W'
     C                   MOVEL     '1'           *IN(WErr)
     C                   ENDIF
     C                   EVAL      WCount = WCount + 1
     C                   EVAL      WErr = WErr + 1
     C                   ENDDO
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = %TRIM(DDREFN + DDCODE)
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
      *
      ** Position cursor on first field if no errors
      *
     C     'N'           LOOKUP    ArrEI                                  73
      *
      ** Protect all fields
      *
     C                   EVAL      *IN70 = *OFF
     C                   IF        PINTYP = 'C'
     C                   EVAL      *IN60 = '1'
     C                   ELSE
     C                   EVAL      *IN60 = '0'
     C                   ENDIF
 
      ** Enquiry Mode
     C                   IF        PINMOD = 'E'
     C                   EVAL      DHEADR = 'Document Management +
     C                                      - Enquiry'
     C                   ELSE
     C                   EVAL      DHEADR = 'Document Management +
     C                                      Maintenance'
     C                   ENDIF
 
      ** Document Status
 
     C                   SELECT
     C                   WHEN      DDSTCD = 'A'
     C                   EVAL      DDSTAT = 'RECEIVED'
     C                   WHEN      DDSTCD = 'C'
     C                   EVAL      DDSTAT = 'DELETED'
     C                   WHEN      DDSTCD = 'O'
     C                   EVAL      DDSTAT = 'OUTSTANDING'
     C                   WHEN      DDSTCD = 'R'
     C                   EVAL      DDSTAT = 'REQUESTED'
     C                   WHEN      DDSTCD = 'Z'
     C                   EVAL      DDSTAT = 'REJECTED'
     C                   OTHER
     C                   EVAL      DDSTAT = *BLANKS
     C                   ENDSL
      *
      ** Enable Key Fields
      *
     C     PEKYFD        COMP      'Y'                                6969
      *
      ** Enable Detail Fields
      *
     C     PEDTFD        COMP      'Y'                                7070
      *
      ** Enable Function Keys
      *
     C     PEINKJ        COMP      'Y'                                    72
     C     PEINKV        COMP      'Y'                                    73
      *
      ** Write Message Subfile, Primary Details and Foiter Screen
      *
     C                   TIME                    DDTIME
 
     C                   IF        CLRSCRN = 'Y'
     C                   WRITE     CLEARDTL
     C                   ENDIF
 
     C                   IF        PHDTFD= 'Y'
     C                   WRITE     SDDCMTS0
     C                   WRITE     SDDCMTF1
     C                   EXFMT     SDDCMTK1
     C                   ENDIF
 
     C                   IF        PHDTFD= 'N'
     C                   WRITE     SDDCMTK1
     C                   WRITE     SDDCMTS0
     C                   WRITE     SDDCMTF1
     C                   EXFMT     SDDCMTD1
     C                   ENDIF
      *
      ** If EXIT/PREVIOUS SCREEN NOT SELECTED
      *
      * Clear message subfile
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     ArrZ0         *IN(9)
      *
      * SET RETURN KEYS
      *
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKV = *INKV
      *
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Document Management (IN SCREEN FORMAT)
     C                   PARM                    DocMgtScn
      *
      * Fields in error
     C                   PARM                    OKFlagsDS
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Enabled key & detail fields
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
      * Enabled function keys
      * KJ = COMMAND KEY 10 = DELETE
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKV
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKV
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly
     C                   PARM                    ISDAFlag
     C                   PARM                    PHDTFD
     C                   PARM                    CLRSCRN
     C                   PARM                    PINTYP
     C                   PARM                    pinmod
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'SDDCMTDSP'
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
      *
     C                   EVAL      *IN97  = '1'
     C                   EVAL      DDPGMQ = '*'
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDMRDT = BJMRDT
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      DBPGM = 'SDDCMTDSP'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
** ArrZ0
000000000000000000000000000000000000000000000000000000000000
