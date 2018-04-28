     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio definition amend checking')         *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM2AD - Portfolio Definition Amend Checking             *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            portfolio definition against those currently on    *
      *            file.  This program also checks whether all fields *
      *            amended are amendable, and if not, an error        *
      *            message will be sent to calling module.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 14May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     D PTRANSIN      E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(A)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D PPMPORT       E DS                  EXTNAME(PMPFDMPD)
      *
      ** Portfolio Definition Fields OK indicators
     D POKPORT       E DS                  EXTNAME(PMEPFDMPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index
     D PIDX            S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRCOMP
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C     PIDX          IFGT      0
     C                   EVAL      PAMENDOK = 'N'
     C                   ELSE
     C                   EVAL      PAMENDOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C     PIDX          IFGT      0
     C     PRESETERR     ANDEQ     'Y'
     C                   EXSR      SRRESETFLDS
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMP - Routine to compare fields from file and the amended *
      *           screen fields                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRCOMP        BEGSR
      *
      ** Portfolio Currency
      *
     C     DDPTCY        IFNE      ADDPTCY
     C                   ADD       1             PIDX
     C                   EVAL      FLDNAMEARR(PIDX) = 'DDPTCY'
     C                   EVAL      MSGIDARR(PIDX)  = 'PMA1001'
     C**********         EVAL      MSGDTAARR(PIDX) = 'Portfolio Currency'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Portfolio Currency'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MSGDTAARR(PIDX) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPTCY          = 'N'
     C                   ENDIF
      *
      ***Portfolio Narrative                                                    CPB002
      ***-*This field is amendable only if customer is a                        CPB002
      *****Portfolio Management Customer.                                       CPB002
      *****                                                                     CPB002
     C*****DDPTFN        IFNE      ADDPTFN                                      CPB002
     C*****PMCUST        ANDNE     'Y'                                          CPB002
     C*****              ADD       1             PIDX                           CPB002
     C*****              EVAL      FLDNAMEARR(PIDX) = 'DDPTFN'                  CPB002
     C*****              EVAL      MSGIDARR(PIDX)  = 'PMA1001'                  CPB002
     C*****              EVAL      MSGDTAARR(PIDX) = 'Portfolio Narrative'      CPB002
     C*****              EVAL      OKPTFN          = 'N'                        CPB002
     C*****              ENDIF                                                  CPB002
      *
      ** Date Closed
      *
     C     DDDPCL        IFNE      ADDDPCL
     C                   ADD       1             PIDX
     C                   EVAL      FLDNAMEARR(PIDX) = 'DDDPCL'
     C                   EVAL      MSGIDARR(PIDX)  = 'PMA1001'
     C**********         EVAL      MSGDTAARR(PIDX) = 'Date Closed'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Date Closed'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MSGDTAARR(PIDX) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDPCL          = 'N'
     C                   ENDIF
      *
      ** Continue validating other non-amendable fields only if
      ** customer is a Portfolio Management customer.
      *
     C     PMCUST        IFEQ      'Y'
      *
      ** Pledge Start Date
      ** - This field is protected in Screen Input and Repair functions
      **   if Portfolio Lending is on.  However, since it is assumed
      **   that this field could be amendable in the front office system,
      **   the checking below needs to be done.
      *
     C     ADDPDGS       IFNE      *BLANK
     C     BGLMCR        ANDEQ     'Y'
      *
     C     DDPDGS        IFNE      ADDPDGS
     C                   ADD       1             PIDX
     C                   EVAL      FLDNAMEARR(PIDX) = 'DDPDGS'
     C                   EVAL      MSGIDARR(PIDX)  = 'PMA1001'
     C**********         EVAL      MSGDTAARR(PIDX) = 'Pledge Start Date'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Pledge Start Date'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MSGDTAARR(PIDX) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPDGS          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Pledge Finish Date
      ** - This field is protected in Screen Input and Repair functions
      **   if Portfolio Lending is on.  However, since it is assumed
      **   that this field could be amendable in the front office system,
      **   the checking below needs to be done.
      *
     C     ADDPDGF       IFNE      *BLANK
     C     BGLMCR        ANDEQ     'Y'
      *
     C     DDPDGF        IFNE      ADDPDGF
     C                   ADD       1             PIDX
     C                   EVAL      FLDNAMEARR(PIDX) = 'DDPDGF'
     C                   EVAL      MSGIDARR(PIDX)  = 'PMA1001'
     C**********         EVAL      MSGDTAARR(PIDX) = 'Pledge Finish Date'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Pledge Finish Date'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MSGDTAARR(PIDX) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPDGF          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Profit Centre
      ** - If switchable feature CAC003 and Analytical Accounting
      **   are switched on, profit centre is amendable only on
      **   day of input.
      *
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
      *
     C     DDPRF2        IFNE      ADDPRF2
     C     WDATE         ANDNE     PDDDPOP
     C                   ADD       1             PIDX
     C                   EVAL      FLDNAMEARR(PIDX) = 'DDPRF2'
     C                   EVAL      MSGIDARR(PIDX)  = 'PMA1001'
     C**********         EVAL      MSGDTAARR(PIDX) = 'Profit Centre'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Profit Centre'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MSGDTAARR(PIDX) = LenStr +%TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPRF2          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETFLDS - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRRESETFLDS   BEGSR
      *
      ** Portfolio Currency
      *
     C     OKPTCY        IFEQ      'N'
     C                   EVAL      ADDPTCY = DDPTCY
     C                   ENDIF
      *
      ** Portfolio Narrative
      *
     C     OKPTFN        IFEQ      'N'
     C                   EVAL      ADDPTFN = DDPTFN
     C                   ENDIF
      *
      ** Date Closed
      *
     C     OKDPCL        IFEQ      'N'
     C                   EVAL      ADDDPCL = DDDPCL
     C                   ENDIF
      *
      ** Pledge Start Date
      *
     C     OKPDGS        IFEQ      'N'
     C     DDPDGS        OREQ      *BLANK
     C                   EVAL      ADDPDGS = DDPDGS
     C                   ENDIF
      *
      ** Pledge Finish Date
      *
     C     OKPDGF        IFEQ      'N'
     C     DDPDGF        OREQ      *BLANK
     C                   EVAL      ADDPDGF = DDPDGF
     C                   ENDIF
      *
      ** Profit Centre
      *
     C     OKPRF2        IFEQ      'N'
     C                   EVAL      ADDPRF2 = DDPRF2
     C                   ENDIF
      *                                                                         CPB002
     C                   EVAL      ADDMGTP = DDMGTP                             CPB002
     C                   EVAL      ADDINTP = DDINTP                             CPB002
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    PTRANSIN
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PPMPORT
      *
      ** Date Opened retrieved from file
      ** - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PRESETERR         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Profit Centre feature
     C                   PARM                    CAC003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKPORT
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMEARR
     C                   PARM                    MSGIDARR
     C                   PARM                    MSGDTAARR
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    PIDX
      *
      ** Amendments OK
     C                   PARM                    PAMENDOK          1
      *
      ** Convert Rundate to date format.
      *
     C                   MOVE      BJRDNB        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      *BLANKS       WDATE             6
     C                   MOVE      ZDATE         WDATE
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
