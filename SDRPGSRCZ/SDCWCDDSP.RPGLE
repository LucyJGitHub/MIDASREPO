     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance Watch Configuration Display')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCWCDDSP - Compliance Watch Configuration Display           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD019             Date 02Jun03               *
      *  Prev Amend No. CSD017             Date 08Nov02               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWCDDF  CF   E             WORKSTN
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of Field Numbers and Names
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D @EI             S              1    DIM(60)
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D CWCDDets      E DS                  EXTNAME(SDCWCMPD)
      ** Compliance Watch Configuration Data Definition File
 
     D OKCWCDDets    E DS                  EXTNAME(SDECWCMPD)
      ** Compliance Watch Configuration Data Error File
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PINKC           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D CSD017          S              1A                                                      CSD017
     D CSD019          S              1A                                                      CSD019
     D C               S              2  0
     D E               S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      SRMAIN
 
      ** Return
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main Processing                                      *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OKCWCDDets    @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C
     C                   Z-ADD     23            E
 
     C                   DOU       C > 60
     C                   IF        @EI(C) = 'N'
     C                   MOVEL     *ON           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    73
 
     C                   IF        CSD017 = 'Y'                                               CSD017
     C                   EVAL      *IN20 =*ON                                                 CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
      ** Write message subfile, record details and footer screen
 
     C                   WRITE     SDCWCDS0
     C                   WRITE     SDCWCDF1
 
      ** Write the alternate detail if CSD019 is installed.                                   CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   WRITE     SDCWCDD2                                                   CSD019
     C                   READ      SDCWCDD2                               73                  CSD019
     C                   ELSE                                                                 CSD019
     C                   WRITE     SDCWCDD1
     C                   READ      SDCWCDD1                               73
     C                   ENDIF                                                                CSD019
 
      ** Set screen error indicators off
 
     C                   MOVEA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
 
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS :
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Compliance Watch Configuration Data Definition File
     C                   PARM                    CWCDDets
      ** Compliance Watch Configuration Data Error File
     C                   PARM                    OKCWCDDets
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
      ** Entry Level WLC Indicator                                                            CSD019
     C                   PARM                    CSD019                                       CSD019
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    PINKC
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCWCDDSP'
 
      ** Move user and workstation ID to screen fields
 
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
** @Z0
000000000000000000000000000000000000000000000000000000000000
