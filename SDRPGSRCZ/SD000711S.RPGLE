     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Document Management Code Selection')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000711S - Midas SD Document Management Selection           *
      *                                                               *
      *  Function:  This program allows a user to select an           *
      *             existing Document Management for use in another   *
      *             program.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD036200           Date 28Oct15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD026556 *CREATE   Date 28Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD036200 - Database error on insert in NAHO                  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026556 - Encountered Database error in override document   *
      *             field from US Indicia                             *
      *           - Applied fix MD024685                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Document Management
     FSDDCMTL8  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Document Management Selection Display File
     FSD000711DFCF   E             WORKSTN SFILE(SD000711S0:DDSFRN)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
 
      ** Subfile Management Indicators
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Documend Code Details Data Structure
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** Non-Accoutn Holder Details Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** For Comment Fields
     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256
 
      ** Program Parameters
     D PRetCde         S              7A
     D PREFN           S                   LIKE(DMREFN)
     D PRTYP           S                   LIKE(DMRTYP)
     D PCODE           S                   LIKE(DMCODE)
     D PSEQN           S              3S 0
 
      ** Access Object Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEYST          S              7A
     D PCNUM           S             10A
     D PNAHO           S             10A
     D PDCCD           S              2A
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
 
      ** Working Variables
     D WCODECNT        S              4P 0
     D WPRecCnt        S              4P 0
     D W0SFRN          S              4P 0
 
     D WPErrFlg        S              1A
     D WPDspFlg        S              1A
     D WPBldFlg        S              1A
 
     D WRun            S              1A
     D WRead           S              1A
     D PPNARN          S             20A                                                    MD036200
     D PPNATW          S             10A                                                    MD036200
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRDCodeMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeMain - Manages the Document Management subfile        *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeMain   BEGSR
 
     C                   EXSR      SRDCodeInit
 
     C                   EXSR      SRDCodeClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRDCodeBld
 
     C                   EXSR      SRDCodeDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   EXSR      SRDCodeVal
 
     C                   IF        WPDspFlg = 'N' AND
     C                             WPBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PREFN = *BLANKS
     C                   EVAL      PRTYP = *BLANKS
     C                   EVAL      PCODE = *BLANKS
     C                   EVAL      PSEQN = *ZERO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeInit - Handles the initial Document Management        *
      *                type subfile processing.                       *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeInit   BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WPErrFlg = 'N'
     C                   EVAL      WPDspFlg = 'N'
     C                   EVAL      WPBldFlg = 'N'
 
      ** Set the file pointer.
 
     C     KCUST         SETLL     SDDCMTL8
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeClr - Clears the Classification Code subfile          *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeClr    BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000711C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeBld - Builds the Document Management subfile          *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeBld    BEGSR
 
      ** Build the subfile only if necessary.
 
     C                   IF        WPDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WPBldFlg = 'Y'
 
     C                   EXSR      SRDCodeClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      DDSFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WPBldFlg = 'N'
 
     C                   IF        INCODE <> *BLANKS
     C                   EVAL      PCODE = INCODE
     C     KCODE         SETLL     SDDCMTL8
     C                   ELSE
     C     KCUST         SETLL     SDDCMTL8
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCODECNT = *ZERO
 
      ** Select all Document Management Code
 
     C     KCUST         READE     SDDCMTL8
 
     C                   DOW       NOT %EOF(SDDCMTL8)
 
 
     C                   IF        DMEXDT > BJRDNB
     C                             OR DMEXDT = *ZERO
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDCODE = DMCODE
     C                   EXSR      SRDOCM
     C                   EVAL      DDDREF = DMDREF
 
     C                   SELECT
     C                   WHEN      DMSTCD = 'A'
     C                   EVAL      DDSTAT = 'RECEIVED'
     C                   WHEN      DMSTCD = 'C'
     C                   EVAL      DDSTAT = 'DELETED'
     C                   WHEN      DMSTCD = 'O'
     C                   EVAL      DDSTAT = 'OUTSTANDING'
     C                   WHEN      DMSTCD = 'R'
     C                   EVAL      DDSTAT = 'REQUESTED'
     C                   WHEN      DMSTCD = 'Z'
     C                   EVAL      DDSTAT = 'REJECTED'
     C                   ENDSL
 
      ** System Status
     C                   EVAL      DDSYST = *BLANKS
     C                   IF        BJRDNB > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                   EVAL      DDSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                   EVAL      DDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
      ** Sequence Number
     C                   MOVEL     DMSEQN        DDSEQN
 
      ** Requested Date
     C                   EVAL      DDRQDT = *BLANKS
     C                   IF        DMRQDT > *ZERO
     C                   EVAL      ZDAYNO = DMRQDT
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         DDRQDT
     C                   ENDIF
 
      ** Required by Date
     C                   EVAL      DDREQB = *BLANKS
     C                   IF        DMREQB > *ZERO
     C                   EVAL      ZDAYNO = DMREQB
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         DDREQB
     C                   ENDIF
 
      ** Expiry Date
     C                   EVAL      DDEXDT = *BLANKS
     C                   IF        DMEXDT > *ZERO
     C                   EVAL      ZDAYNO = DMEXDT
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         DDEXDT
     C                   ENDIF
 
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      DDSFRN = W0SFRN
     C                   EVAL      WCODECNT = WCODECNT + 1
     C                   WRITE     SD000711S0
     C                   ENDIF
 
      ** Leave the Document Management selection if one subfile
      ** page has been filled.
 
     C                   IF        WCODECNT = 17
 
      ** Check first if there are more records available.
 
     C     KCUST         READE     SDDCMTL8
 
     C                   IF        %EOF
     C                   LEAVE
     C                   ELSE
     C     KCUST         READPE    SDDCMTL8
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C     KCUST         READE     SDDCMTL8
 
     C                   ENDDO
 
      ** No Details to Display.
 
     C                   IF        W0SFRN = *ZERO
     C                   EVAL      PMsgID = 'USR7620'
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeDsp - Displays the Document Management subfile        *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeDsp    BEGSR
 
      ** Display the full Document Management selection screen.
 
     C                   WRITE     SD000711F0
     C                   WRITE     SD000711C1
     C                   WRITE     SD000711F1
     C                   EXFMT     SD000711C0
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCodeVal - Validates the Document Management subfile       *
      *                                                               *
      *****************************************************************
 
     C     SRDCodeVal    BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WPErrFlg = 'N'
     C                   EVAL      WPDspFlg = 'N'
     C                   EVAL      WPBldFlg = 'N'
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WPRecCnt = *ZERO
 
     C                   READC     SD000711S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Action Code.
 
     C                   EXSR      SRVPActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000711S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000711S0
 
     C                   ENDDO
 
     C                   IF        WPErrFlg = 'Y'
     C                   EVAL      WPDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000711S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        DDACTN = '1'
 
      ** At this point, a valid Document Management Code has been selected.
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PCODE = DDCODE
     C                   MOVEL     DDSEQN        PSEQN
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000711S0
 
     C                   ENDDO
 
     C                   EVAL      WPBldFlg = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPActCde - Validates the Action Code.                      *
      *                                                               *
      *****************************************************************
 
     C     SRVPActCde    BEGSR
 
     C                   IF        DDACTN <> *BLANKS
 
      ** Action Code must be '1' (Select).
 
     C                   IF        DDACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WPErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR9358'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   EVAL      WPRecCnt = WPRecCnt + 1
 
     C                   IF        WPRecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WPErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USS0108'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDOCM - Access Document Code for Details                    *
      *                                                               *
      *****************************************************************
     C     SRDOCM        BEGSR
 
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DMCODE        PDCCD
     C     SDDOCM        PARM      SDDOCM        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBASE = 904
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDNARR = ATDCNA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDate2 - Format Date for output                             *
      *                                                               *
      *****************************************************************
 
     C     SRDate2       BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the Program Message       *
      *             Queue via ZA0340.                                 *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    PRetCde
 
      ** Document Management Code
 
     C                   PARM                    PREFN
     C                   PARM                    PRTYP
     C                   PARM                    PCODE
     C                   PARM                    PSEQN
     C                   PARM                    PPNARN                                     MD036200
     C                   PARM                    PPNATW                                     MD036200
 
      ** End Parameter List
      ** ==================
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the system information display fields.
 
     C                   EVAL      DDRUNA = BJMRDT
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C                   EVAL      DDREFN = PREFN
     C                   IF        PRTYP = 'C'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      PCNUM = PREFN
      ** Customer
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKEYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = PCNUM
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRTN = BBCRTN
     C                   EVAL      DDCRNM = BBCRNM
     C                   ENDIF
     C                   ELSE
      ** Non-Account Holder
     C                   EVAL      PNAHO = PREFN
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY
     C                   IF        PRTCD <> *BLANKS
     C**********         EVAL      DBFILE = 'SDNAHOPD'                                      MD036200
     C**********         EVAL      DBASE = 903                                              MD036200
     C**********         EVAL      DBKEY = PNAHO                                            MD036200
     C**********         OUT       LDA                                                      MD036200
     C**********         EXSR      *PSSR                                                    MD036200
     C                   EVAL      DDCRNM = PPNARN                                          MD036200
     C                   EVAL      DDCRTN = PPNATW                                          MD036200
     C                   ELSE
     C                   EVAL      DDCRTN = NHNATW
     C                   EVAL      DDCRNM = NHNARN
     C                   ENDIF
     C                   ENDIF
 
     C     KCODE         KLIST
     C                   KFLD                    PREFN
     C                   KFLD                    PRTYP
     C                   KFLD                    PCODE
 
     C     KCUST         KLIST
     C                   KFLD                    PREFN
     C                   KFLD                    PRTYP
 
     C     KCUST         SETLL     SDDCMTL8
     C     KCUST         READE     SDDCMTL8
     C                   IF        NOT %EOF
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2014
