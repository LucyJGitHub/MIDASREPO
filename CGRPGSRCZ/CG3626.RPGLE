     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Write Data to Stream File')                   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3626 - Write Data to Stream File                           *
      *                                                               *
      *  Function: This sub-module receives parameters from CG3625    *
      *            and process as follows:                            *
      *                                                               *
      *            a) *GEN - do nothing                               *
      *            b) *WRITE - write CGUXMLPD data into stream file.  *
      *            c) *CLOSE - do nothing                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD062272           Date 22Jan24               *
      *  Prev Amend No. MD061852           Date 20Oct23               *
      *                 BA6020             Date 03Sep13               *
      *                 255619             Date 11Aug22               *
      *                 MD055442           Date 01Jun20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD027486           Date 23Jun15               *
      *                 CSD053A            Date 14Dec12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CCG015  *CREATE    Date 03Sep01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062272 - Close of CGUXMLL0 should only be done if no DOCS  *
      *             tag is found. Remove MP1.4 changes for GSH020CC2, *
      *             so that extra <SYSTEMCUSTOM> tags are not output. *
      *  MD061852 - UDC_PRTGEN failed i/o operation was applied to    *
      *             closed file CGUXMLL0 in FusionMidas.              *
      *           - Open and close file CGUXMLL0 when #@ARCH <> 'A'.  *
      *           - Fix is for BA6020.                                *
/*    *  BA6020 - Add specific header field to CM XML output          *
      *  255619 - Applied fix 252870.                                 *
      *  252870 - Zero-byte file transferred by CM.                   *
      *  MD055442 - Correspondence manager - pick up Czech CCSID 870. *
      *           - Replace & with &amp; instead of using CDATA.      *
      *             Also replace < with &lt; and > with &gt;          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027486 - Tag contains '£CDATA£' rather than '[CDATA[       *
      *             Use character '[' instead of '£' in formatting    *
      *             the Tag value field                               *
      *             Applied for MD031921.                             *
      *  CSD053A - Correspondence Manager DBCS Support                *
      *            Applied for AR924785 (Child: AR924788)             *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      /EJECT
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+
      *  XML Merged Data by Item Reference (Current)
     F***CGUXMLL0  IF   E           K DISK                                                    252870
     FCGUXMLL0  IF   E           K DISK    USROPN                                             252870

      *  XML Merged Data by Item Reference (Archive)
     FCGXXMLL0  IF   E           K DISK

      *                                                                                       BA6020
     FCGUXMHPD  IF   E             DISK                                                       BA6020
      *                                                                                       BA6020
     FA6RDEXL0  IF   E           K DISK                                                       BA6020
      *                                                                                       BA6020
      /EJECT
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO

      * +------------------------------------------------------+
      * ¦ READ API() definitions for oflag and mode parameters ¦
      * +------------------------------------------------------+
      /COPY CGCPYSRC,OPENDFN

      * +-------------------------------------------------+
      * ¦ Variable declaration for the IFS APIs used here ¦
      * +-------------------------------------------------+
     D FileDesc        S             10I 0
     D Oflag           S             10I 0 INZ

      * +-----------------------------------------------+
      * ¦ Variable declaration for *WRITE mode to *STMF ¦
      * +-----------------------------------------------+
     D RecordData      S            135    INZ(*BLANKS)
     D  TagName        S             33    INZ(*BLANKS)
     D  TagValue       S             65    INZ(*BLANKS)
     D  ConvValue      S             80    INZ(*BLANKS)
     D  TagEnd         S             33    INZ(*BLANKS)

      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D RC              S             10I 0
     D Count           S              5P 0 INZ
     D*Buffer***       S            250A   INZ(*BLANK)                                        CSD053
     D*pBuffer**       S               *   INZ(%ADDR(Buffer))                                 CSD053
     D BigString       S           1000
     D i               S              3  0 INZ(0)
     D Pos             S              5  0
     D Head            S            230
     D Output          S           1000C   CCSID(1200)                                        CSD053
     D BOM             S             10A                                                      CSD053

     D RtnCode         S              7
     D ActCode         S              6

      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1

      * +-------------------------+
      * ¦ Parameters for AOCORMR0 ¦
      * +-------------------------+
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)

      * +-----------------------+
      * ¦ Parameters for CG3627 ¦
      * +-----------------------+
     D StrTag          S             33    DIM(200)
     D Value           S             65    DIM(200)
     D EndTag          S             33    DIM(200)

      * +----------------------------------------+
      * ¦ Variables for writing into Stream File ¦
      * +----------------------------------------+
     D HeadLine        S            100
     D CorrLine        S            184
     D SysLine         S            135
     D WFlag           S              1
     D RootFnd         S              1                                                       BA6020
     D DocSFnd         S              1                                                       BA6020
     D BYPS            S              1                                                       BA6020
     D BA6020          S              1                                                       BA6020
     D POption         S              7A                                                      BA6020
     D PRtnCode        S              7A                                                      BA6020
     D PSARD           S              6A                                                      BA6020
     D InHousePgm      S             10A   INZ(*BLANK)                                        BA6020
     D W#SCHEMA        S             50A                                                      BA6020
     D P@SCHEMA        S                   LIKE(W#SCHEMA)                                     BA6020
     D COLON           S              1A   INZ(':')                                           BA6020
     D W#ARGT          S            111A                                                      BA6020
     D W#TYPE          S              4A   INZ('REFR')                                        BA6020
     D WSysCus         S              1                                                       BA6020
                                                                                             CSD053A
     D Buffer          S            250A   INZ(*BLANK)                                       CSD053A
     D pBuffer         S               *   INZ(%ADDR(Buffer))                                CSD053A
     D AllowDBCS       S              1                                                      CSD053A
      *                                                                                       BA6020
      ** Parameters for AOSVALR0                                                              BA6020
      *                                                                                       BA6020
     D P@OP01          S             20    INZ                                                BA6020
     D P@VL01          S            200    INZ                                                BA6020
     D P@OP02          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL02          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP03          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL03          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP04          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL04          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP05          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL05          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP06          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL06          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP07          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL07          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP08          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL08          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP09          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL09          S                   LIKE(P@VL01) INZ                                   BA6020
     D P@OP10          S                   LIKE(P@OP01) INZ                                   BA6020
     D P@VL10          S                   LIKE(P@VL01) INZ                                   BA6020
     D I#Rtcd          S              7    INZ(*BLANK)                                        BA6020
      *                                                                                       BA6020

      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D*XMLHead1*       C                   'xml version="1.0" encoding="UTF-8"'               CSD053
     D***XMLHead1        C                   'xml version="1.0" encoding="UTF-16"     CSD053 CSD053A
     D XMLHead1        C                   '?xml version="1.0" encoding= +                   CSD053A
     D                                          "ISO-8859-1"?'                               CSD053A
     D CRLF            C                   X'0D25'
     D Null            C                   X'00'
     D ROOTS           C                   '<ROOT>'                                           BA6020
     D DOCS            C                   '<DOCUMENT>'                                       BA6020
     D DOCE            C                   '</DOCUMENT>'                                      BA6020
     D ROOTE           C                   '</ROOT>'                                          BA6020
     D SYSCUSS         C                   '<SYSTEMCUSTOM>'                                   BA6020
     D SYSCUSE         C                   '</SYSTEMCUSTOM>'                                  BA6020

      * +-----------------------------------------------+
      * ¦ Data structure for Correspondence Manager ICD ¦
      * +-----------------------------------------------+
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)

      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)

      * +----------------------------------------------------+
      * ¦ System Local Data Area to hold <OutputInformation> ¦
      * +----------------------------------------------------+
     D Cglda         E DS                  EXTNAME(CGLDA)

      * +----------------------------------------------+
      * ¦ Data structure for Print Process driver file ¦
      * +----------------------------------------------+
     D PrtGen        E DS                  EXTNAME(CGPGENPD)

      * +------------------------------------------------------+
      * ¦ Local Data Area Structure for error handling routine ¦
      * +------------------------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *  LDA definition :                   134 141 DBFILE
      *                                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *                                     184 193 DBMOD
      *                                     194 203 DBPROC
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  BA6020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     BA6020
      * +-----------------------------------------------------------------+
      * ¦ The following /COPY line includes all the defined fields in the ¦
      * ¦ PSDS.  They have meaningful names, prefixed by 'PS'.            ¦
      * +-----------------------------------------------------------------+
     D/COPY ZACPYSRC,PSDS

      * +-------------------------------------------------------------+
      * ¦ Function to return formatted Tag Value field if it contains ¦
      * ¦ special characters in the text.                             ¦
      * +-------------------------------------------------------------+
     DScanFld          PR            80
     D TagValue                            LIKE(XMTAGV)

      * +-------------------------------------------------------------+
      * ¦ Function to convert in Ascii characters according to the    ¦
      * ¦ conversion table ASCII.                                     ¦
      * +-------------------------------------------------------------+
     DConvertAscii     PR          1000
     DInputData                    1000

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Main Routine                                                ¦
      * +-------------------------------------------------------------+
     C                   SELECT

      * +-------------------------------------------------------------+
      * ¦ Mode = *GEN                                                 ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*GEN  '
      *                                                                                       BA6020
      * EPOX assumes that all extracts will be valid XML.  Therefore                          BA6020
      * only one XML declaration is required per DAT file.                                    BA6020
      * Only one ROOT element is required per DAT file.  Misys code                           BA6020
      * will generate the root element because the original design -                          BA6020
      * that the root element be injected via the custom data extract -                       BA6020
      * does not work for DAT files containing multiple extracts.                             BA6020
      *                                                                                       BA6020
     C     BA6020        IFEQ      'Y'                                                        BA6020
      *                                                                                       BA6020
      ** Write XML Heading line                                                               BA6020
     C                   EXSR      WRTHEAD                                                    BA6020
      *                                                                                       BA6020
     C                   ENDIF                                                                BA6020
                                                                                              BA6020

      * +-------------------------------------------------------------+
      * ¦ Mode = *WRITE                                               ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*WRITE'

      *  Setup system data area
     C                   EXSR      SETLDA

     C     BA6020        IFEQ      'N'                                                        BA6020
                                                                                              BA6020
      *  Write XML Heading line
     C                   EXSR      WRTHEAD
                                                                                              BA6020
     C                   ENDIF                                                                BA6020

      *  Write XML data from PF/CGUXMLPD
     C                   EXSR      WRTDET

      * +-------------------------------------------------------------+
      * ¦ Mode = *CLOSE                                               ¦
      * +-------------------------------------------------------------+
     C                   WHEN      ActCode = '*CLOSE'
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
     C                   EXSR      WRTCLS                                                     BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020

     C                   ENDSL
      *
     C                   RETURN

      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR

      *  Define parameter passed from calling program
     C     *ENTRY        PLIST
     C                   PARM                    ActCode
     C                   PARM                    PrtGen
     C                   PARM                    FileDesc
     C                   PARM                    RtnCode
     C                   PARM                    AllowDBCS                                   CSD053A

      *  Define work dataarea
     C     *DTAARA       DEFINE    *LDA          Cglda

      *  Retrieve Correspondence Manager ICD
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy

      * Error calling AOCORMR0
     C                   IF        %ERROR OR Rtcd <> *BLANK

     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR

     C                   ENDIF
      *                                                                                       BA6020
      ** Check if BA6020 feature is on.                                                       BA6020
      *                                                                                       BA6020
     C                   EVAL      BA6020 = 'N'                                               BA6020
     C                   CALL      'AOSARDR0'                                                 BA6020
     C                   PARM      *BLANKS       PRtnCode                                     BA6020
     C                   PARM      '*VERIFY'     POption                                      BA6020
     C                   PARM      'BA6020'      PSARD                                        BA6020
     C     SCSARD        PARM      SCSARD        DSFDY                                        BA6020
      *                                                                                       BA6020
     C                   IF        PRtnCode <> *Blanks  and                                   BA6020
     C                             PRtnCode <> '*NRF'                                         BA6020
     C                   EVAL      DBFILE = 'AOSARDR0'                                        BA6020
     C                   EVAL      DBKEY = POption                                            BA6020
     C                   EVAL      DBASE  = 11                                                BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   IF        PRtnCode = *BLANKS                                         BA6020
     C                   EVAL      BA6020 = 'Y'                                               BA6020
      *                                                                                       BA6020
      ** Access the system value                                                              BA6020
      *                                                                                       BA6020
     C                   EVAL      P@OP01 = 'BA6020_InHousePgm'                               BA6020
      *                                                                                       BA6020
     C                   CALL      'AOSVALR0'                                                 BA6020
     C                   PARM      *BLANKS       I#Rtcd                                       BA6020
     C                   PARM                    P@OP01                                       BA6020
     C                   PARM      *BLANKS       P@VL01                                       BA6020
     C                   PARM      *BLANKS       P@OP02                                       BA6020
     C                   PARM      *BLANKS       P@VL02                                       BA6020
     C                   PARM      *BLANKS       P@OP03                                       BA6020
     C                   PARM      *BLANKS       P@VL03                                       BA6020
     C                   PARM      *BLANKS       P@OP04                                       BA6020
     C                   PARM      *BLANKS       P@VL04                                       BA6020
     C                   PARM      *BLANKS       P@OP05                                       BA6020
     C                   PARM      *BLANKS       P@VL05                                       BA6020
     C                   PARM      *BLANKS       P@OP06                                       BA6020
     C                   PARM      *BLANKS       P@VL06                                       BA6020
     C                   PARM      *BLANKS       P@OP07                                       BA6020
     C                   PARM      *BLANKS       P@VL07                                       BA6020
     C                   PARM      *BLANKS       P@OP08                                       BA6020
     C                   PARM      *BLANKS       P@VL08                                       BA6020
     C                   PARM      *BLANKS       P@OP09                                       BA6020
     C                   PARM      *BLANKS       P@VL09                                       BA6020
     C                   PARM      *BLANKS       P@OP10                                       BA6020
     C                   PARM      *BLANKS       P@VL10                                       BA6020
      *                                                                                       BA6020
     C                   IF        I#Rtcd <> *BLANKS                                          BA6020
     C                   EVAL      DBFILE =  'SDSVLXTD'                                       BA6020
     C                   EVAL      DBPGM  =  P@OP01                                           BA6020
     C                   EVAL      DBASE  =  014                                              BA6020
     C                   EVAL      DBMOD  =  PSProcMod                                        BA6020
     C                   EXSR      *PSSR                                                      BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   MOVEL     P@VL01        InHousePgm                                   BA6020
                                                                                              BA6020
     C                   ENDIF                                                                BA6020
                                                                                              BA6020
     C     K#RDEC        KLIST                                                                BA6020
     C                   KFLD                    W#TYPE                                       BA6020
     C                   KFLD                    W#ARGT                                       BA6020

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTHEAD - Write XML Heading line                       ¦
      * +-------------------------------------------------------------+
     C     WRTHEAD       BEGSR

      *  Write header only if details line exists
      *  This situation may happen if Correspondence Manager
      *  is installed with former UDC extract files (CGUDT*)
      ** Wait for a while and check if the UXML records are available.                        252870
      *                                                                                       252870
     C                   DOU       *IN50 = *ON                                                252870
      *                                                                                       252870
     C                   IF        #@ARCH = 'A'
     C*****B2ITEM        SETLL     CGXXMLL0                                                   252870
     C**********         IF        NOT %EQUAL                                                 252870
     C**********         LEAVESR                                                              252870
     C**********         ENDIF                                                                252870
     C     B2ITEM        SETLL     CGXXMLL0                               50                  252870
     C                   ELSE
     C*****B2ITEM        SETLL     CGUXMLL0                                                   252870
     C**********         IF        NOT %EQUAL                                                 252870
     C**********         LEAVESR                                                              252870
     C**********         ENDIF                                                                252870
     C                   OPEN      CGUXMLL0                                                   252870
     C     B2ITEM        SETLL     CGUXMLL0                               50                  252870
     C                   CLOSE     CGUXMLL0                                                   252870
     C                   ENDIF
      *                                                                                       252870
     C                   ENDDO                                                                252870

      *  Format Byte Order Mark (Unicode Big Endian = x'FEFF')                                CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      BOM = x'FEFF'                                              CSD053
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(BOM) :                         CSD053
     C                                         %LEN(%TRIMR(BOM)))                             CSD053
     C                   ENDIF                                                               CSD053A
      *  Format XML Heading line
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      HeadLine = '<' + %TRIM(CMHDSC) + '>'
     C                   ELSE                                                                CSD053A
     C                   EVAL      HeadLine = '<' + %TRIM(XMLHead1) + '>'                    CSD053A
     C                   ENDIF                                                               CSD053A

      *  Attach CRLF
     C                   EVAL      BigString = %TRIM(HeadLine) + CRLF
     C**********         EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A

      *  Write XML Heading line into the stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CSD053A
     C                   ENDIF                                                               CSD053A

      *  Error encountered, issue error screen and dump the program
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANKS
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF

      *                                                                                       BA6020
      * Only one ROOT element is required per DAT file.  Misys code                           BA6020
      * will generate the root element because the original design -                          BA6020
      * that the root element be injected via the custom data extract -                       BA6020
      * does not work for DAT files containing multiple extracts.                             BA6020
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
      *                                                                                       BA6020
     C                   EVAL      BigString = %TRIM(ROOTS) + CRLF                            BA6020
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          BA6020
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       BA6020
     C                                         %LEN(%TRIMR(Output))*2)                        BA6020
      *                                                                                       BA6020
      ** If error writing to stream file                                                      BA6020
      *                                                                                       BA6020
     C                   IF        RC = -1                                                    BA6020
     C                   EVAL      DBFILE =  *BLANK                                           BA6020
     C                   EVAL      DBPGM  =  PSProcPgm                                        BA6020
     C                   EVAL      DBASE  =  906                                              BA6020
     C                   EVAL      DBMOD  =  PSProcMod                                        BA6020
                                                                                              BA6020
     C                   EXSR      *PSSR                                                      BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
      ** Get schema name.                                                                     BA6020
      *                                                                                       BA6020
     C                   EVAL      W#ARGT = %TRIM(B2PTYP) + COLON +                           BA6020
     C                               %TRIM(B2PSTP)                                            BA6020
     C     K#RDEC        CHAIN     A6RDEXL0                                                   BA6020
     C                   IF        %FOUND(A6RDEXL0)                                           BA6020
     C                   EVAL      W#SCHEMA = %TRIM(CGNWFD)                                   BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
      ** Build the START element and its sub-elements.                                        BA6020
      *                                                                                       BA6020
     C                   CALL      InHousePgm                                                 BA6020
     C                   PARM      W#SCHEMA      P@SCHEMA                                     BA6020
      *                                                                                       BA6020
      ** Write the START element and its sub-elements.                                        BA6020
      ** Reset file pointer because in house program clears file when called.                 BA6020
      *                                                                                       BA6020
     C     1             SETLL     CGUXMHPD                                                   BA6020
     C                   READ      CGUXMHPD                                                   BA6020
     C                   DOW       NOT %EOF                                                   BA6020
     C                   MOVE(P)   XHTAGN        TagName                                      BA6020
     C                   MOVE(P)   XHTAGV        TagValue                                     BA6020
     C                   MOVE(P)   XHENDT        TagEnd                                       BA6020
      *                                                                                       BA6020
      ** Scan tag value for special characters (i.e. '&','<', '>'),                           BA6020
      ** if so, format field as '<![CDATA[Tag Value]]>'.                                      BA6020
      *                                                                                       BA6020
     C                   EVAL      ConvValue = ScanFld(TagValue)                              BA6020
      *                                                                                       BA6020
      ** Combine data into a single compressed field.                                         BA6020
      *                                                                                       BA6020
     C                   EVAL      RecordData = %TRIM(TagName)+                               BA6020
     C                              %TRIM(ConvValue) + %TRIM(TagEnd)                          BA6020
      *                                                                                       BA6020
      ** Attach CRLF at the end of each record line                                           BA6020
      *                                                                                       BA6020
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF                       BA6020
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          BA6020
      *                                                                                       BA6020
      ** Write record to stream file                                                          BA6020
      *                                                                                       BA6020
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       BA6020
     C                                         %LEN(%TRIMR(Output))*2)                        BA6020
      *                                                                                       BA6020
      ** If error writing to stream file                                                      BA6020
      *                                                                                       BA6020
     C                   IF        RC = -1                                                    BA6020
     C                   EVAL      DBFILE =  *BLANK                                           BA6020
     C                   EVAL      DBPGM  =  PSProcPgm                                        BA6020
     C                   EVAL      DBASE  =  907                                              BA6020
     C                   EVAL      DBMOD  =  PSProcMod                                        BA6020
      *                                                                                       BA6020
     C                   EXSR      *PSSR                                                      BA6020
     C                   ENDIF                                                                BA6020
     C                   READ      CGUXMHPD                                                   BA6020
     C                   ENDDO                                                                BA6020
      *                                                                                       BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/SETLDA - Set up Print Process Communications Data      ¦
      * ¦               Area.                                         ¦
      * +-------------------------------------------------------------+
     C     SETLDA        BEGSR

      *  Update Cglda with relevant Print Process data
     C                   IN        Cglda

     C                   EVAL      #@ITEM = B2ITEM
     C                   EVAL      #@DCOR = B2DCOR
     C                   EVAL      #@UNT  = B2LGID

     C                   OUT       Cglda

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTSYS  - Write SYSTEM FIELD information into the      ¦
      * ¦                Stream File. The data will be retrieved via  ¦
      * ¦                call to CG3627.                              ¦
      * +-------------------------------------------------------------+
     C     WRTSYS        BEGSR

      *  Call program to retrieve formatted system fields. Output of
      *  CG3627 are arrays StrTag, Value and EndTag (all of which has
      *  dimension = 200 elements)

     C                   CALLB(E)  'CG3627'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      *BLANKS       StrTag
     C                   PARM      *BLANKS       Value
     C                   PARM      *BLANKS       EndTag

      *  Error encountered, issue error screen and dump the program
     C                   IF        %ERROR OR Rtcd = '*ERROR '
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR

      *  otherwise, write array data into the stream file
     C                   ELSE

      *  Initialise array counter and process array
     C                   EVAL      i = 1
     C                   EVAL      Count = 1

     C                   DOW       Count < %ELEM(StrTag) AND
     C                               StrTag(i) <> *BLANK
      *  Scan tag value for special characters (i.e. '&','<', '>'),
      *  if so, format field as '<!£CDATA£Tag Value]]>'.
     C                   EVAL      ConvValue = ScanFld(Value(i))

      *  Combine Start Tag + Value + End Tag into one compressed field.
     C                   EVAL      SysLine = %TRIM(StrTag(i))
     C                                + %TRIM(ConvValue) + %TRIM(EndTag(i))

      *  Attach CRLF at the end of each line
     C                   EVAL      BigString = %TRIM(SysLine) + CRLF
     C**********         Eval      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A

      *  Write data into stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CSD053A
     C                   ENDIF                                                               CSD053A

      *  Error encountered, issue error screen and dump the program
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF

      *  Process next set of data in the array
     C                   EVAL      i = i + 1
     C                   EVAL      Count = Count + 1

     C                   ENDDO
     C                   ENDIF

     C                   ENDSR

      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRTDET  - Write Merged XML Correspondent details       ¦
      * ¦                into the stream file.                        ¦
      * +-------------------------------------------------------------+
     C     WRTDET        BEGSR

      *  Output first the whole block starting by element '<ROOT>' and ending                 BA6020
      *  with the element preceeding '</DOCUMENT>.                                            BA6020
      *                                                                                       BA6020
     C                   EVAL      BYPS   = 'N'                                               BA6020
     C                   EVAL      RootFnd = 'N'                                              BA6020
     C                   EVAL      DocSFnd = 'N'                                              BA6020
     C                   EVAL      WSysCus = 'N'                                              BA6020
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
      *                                                                                       BA6020
     C                   IF        #@ARCH = 'A'                                               BA6020
     C     B2ITEM        SETLL     CGXXMLL0                                                   BA6020
     C     B2ITEM        READE     CGXXMLL0                                                   BA6020
     C                   ELSE                                                                 BA6020
     C                   OPEN      CGUXMLL0                                                   BA6020
     C     B2ITEM        SETLL     CGUXMLL0                                                   BA6020
     C     B2ITEM        READE     CGUXMLL0                                                   BA6020
     C                   ENDIF                                                                BA6020
     C                   IF        DOCS = %TRIM(XMTAGN)                                       BA6020
     C                   EVAL      DocSFnd = 'Y'                                              BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   IF        DocSFnd = 'N'                                              BA6020
     C                   DOU       %EOF                                                       BA6020
     C                             OR DOCS = %TRIM(XMTAGN)                                    BA6020
     C                   IF        #@ARCH = 'A'                                               BA6020
     C     B2ITEM        READE     CGXXMLL0                                                   BA6020
     C                   ELSE                                                                 BA6020
     C     B2ITEM        READE     CGUXMLL0                                                   BA6020
     C                   ENDIF                                                                BA6020
     C                   ENDDO                                                                BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C**********         IF        #@ARCH <> 'A'                                     BA6020 MD062272
     C                   IF        #@ARCH <> 'A' and                                        MD062272
     C                             DOCS <> %TRIM(XMTAGN)                                    MD062272
     C                   CLOSE     CGUXMLL0                                                   BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   IF        DOCS = %TRIM(XMTAGN)                                       BA6020
     C                   EVAL      DocSFnd = 'Y'                                              BA6020
      *                                                                                       BA6020
      ** Output until '</DOCUMENT> is reached.                                                BA6020
     C                   DOU       %EOF                                                       BA6020
     C                             OR XMTAGN = DOCE                                           BA6020
      *                                                                                       BA6020
      ** Load records into work fields.                                                       BA6020
     C                   MOVE(P)   XMTAGN        TagName                                      BA6020
     C                   MOVE(P)   XMTAGV        TagValue                                     BA6020
     C                   MOVE(P)   XMENDT        TagEnd                                       BA6020
      *                                                                                       BA6020
      ** Scan tag value for special characters (i.e. '&','<', '>'),                           BA6020
      ** if so, format field as '<!£CDATA£Tag Value]]>'.                                      BA6020
     C                   EVAL      ConvValue = ScanFld(TagValue)                              BA6020
      *                                                                                       BA6020
      ** Combine data into a single compressed field.                                         BA6020
     C                   EVAL      RecordData = %TRIM(TagName)+                               BA6020
     C                              %TRIM(ConvValue) + %TRIM(TagEnd)                          BA6020
      *                                                                                       BA6020
      ** Attach CRLF at the end of each record line                                           BA6020
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF                       BA6020
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          BA6020
      *                                                                                       BA6020
      * Write record to stream file                                                           BA6020
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       BA6020
     C                                         %LEN(%TRIMR(Output))*2)                        BA6020
      *                                                                                       BA6020
      ** If error writing to stream file                                                      BA6020
     C                   IF        RC = -1                                                    BA6020
     C                   EVAL      DBFILE =  *BLANK                                           BA6020
     C                   EVAL      DBPGM  =  PSProcPgm                                        BA6020
     C                   EVAL      DBASE  =  006                                              BA6020
     C                   EVAL      DBMOD  =  PSProcMod                                        BA6020
     C                   EXSR      *PSSR                                                      BA6020
     C                   ENDIF                                                                BA6020
     C                                                                                        BA6020
     C                   IF        #@ARCH = 'A'                                               BA6020
     C     B2ITEM        READE     CGXXMLL0                                                   BA6020
     C                   ELSE                                                                 BA6020
     C                   IF        NOT %OPEN(CGUXMLL0)                                      MD061852
     C                   OPEN      CGUXMLL0                                                 MD061852
     C                   ENDIF                                                              MD061852
     C     B2ITEM        READE     CGUXMLL0                                                   BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDDO                                                                BA6020
     C                   IF        #@ARCH <> 'A'                                            MD061852
     C                   CLOSE     CGUXMLL0                                                 MD061852
     C                   ENDIF                                                              MD061852
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
      *  Initialise WFlag to write the System Field info ONLY ONCE
      *  and ONLY AFTER writing the first record from XML file for
      *  the current item.
     C                   EVAL      WFlag = 'N'

      *  Read records for this Item Reference from the XML Merged file.
      *  The file being processed depends on the value of Archive Flag
      *  in Cglda (*LDA): if LIVE request, read from CGUXMLPD
      *                   if ARCHIVE request, read from CGXXMLPD

     C                   IF        #@ARCH = 'A'
     C     B2ITEM        SETLL     CGXXMLL0
     C     B2ITEM        READE     CGXXMLL0
     C                   ELSE
     C                   OPEN      CGUXMLL0                                                   252870
     C     B2ITEM        SETLL     CGUXMLL0
     C     B2ITEM        READE     CGUXMLL0
     C                   ENDIF

     C                   DOW       NOT %EOF
      *                                                                                       BA6020
      ** Bypass the <ROOT> group.                                                             BA6020
     C                   IF        XMTAGN = DOCS  AND                                         BA6020
     C                             BA6020 = 'Y'                                               BA6020
     C                   EVAL      BYPS   = 'Y'                                               BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C**********         If        BYPS = 'N' and WSysCus = 'N'                      BA6020 MD062272
     C**********                     and BA6020 = 'Y'                                BA6020 MD062272
      ***Output*<SYSTEMCUSTOM>*before*1st*detail*line*of*correspondence.             BA6020 MD062272
     C**********         MOVE(P)   SYSCUSS       TagName                             BA6020 MD062272
     C**********         MOVE(P)   *BLANKS       TagValue                            BA6020 MD062272
     C**********         MOVE(P)   *BLANKS       TagEnd                              BA6020 MD062272
     C**********         EVAL      RecordData = %TRIM(TagName)                       BA6020 MD062272
     C**********         EVAL      BigString = %TRIM(RecordData) + CRLF              BA6020 MD062272
     C**********         Eval      Output = %TRIMR(%UCS2(BigString))                 BA6020 MD062272
     C**********         EVAL      RC = WRITE(FileDesc : %ADDR(Output):              BA6020 MD062272
     C**********                               %LEN(%TRIMR(Output))*2)               BA6020 MD062272
      **********                                                                     BA6020 MD062272
      ***If*error*writing*to*stream*file                                             BA6020 MD062272
     C**********         IF        RC = -1                                           BA6020 MD062272
     C**********         EVAL      DBFILE =  *BLANK                                  BA6020 MD062272
     C**********         EVAL      DBPGM  =  PSProcPgm                               BA6020 MD062272
     C**********         EVAL      DBASE  =  990                                     BA6020 MD062272
     C**********         EVAL      DBMOD  =  PSProcMod                               BA6020 MD062272
     C**********         EXSR      *PSSR                                             BA6020 MD062272
     C**********         ENDIF                                                       BA6020 MD062272
      **********                                                                     BA6020 MD062272
      ***Set*flag*indicating*<SYSTEMCUSTOM>*has*been*output.                         BA6020 MD062272
     C**********         Eval      WSysCus = 'Y'                                     BA6020 MD062272
      **********                                                                     BA6020 MD062272
     C**********         Endif                                                       BA6020 MD062272
      **********                                                                     BA6020 MD062272

      *  Load records into work fields.
     C                   MOVE(P)   XMTAGN        TagName
     C                   MOVE(P)   XMTAGV        TagValue
     C                   MOVE(P)   XMENDT        TagEnd

     C                   IF        BYPS = 'N' AND BA6020 = 'Y'                                BA6020
     C                             OR BA6020 = 'N'                                            BA6020
      * Format the header if it's the first record read for a given
      * item number
     C                   IF        WFlag = 'N'

     C                   EVAL      Pos = %SCAN('>':TagName)
     C                   EVAL      Head = '<' + %SUBST(TagName:2:Pos-2)
     C                             + ' '+ %TRIM(CMSTY1) + '"'
     C                             + %SUBST(TagName:2:Pos-2) + '.xsd">'
     C                   EVAL      BigString = %TRIM(Head) + CRLF
     C**********         EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             CSD053A
     C                   ELSE
      *  Scan tag value for special characters (i.e. '&','<', '>'),
      *  if so, format field as '<!£CDATA£Tag Value]]>'.
     C                   EVAL      ConvValue = ScanFld(TagValue)

      *  Combine data into a single compressed field.
     C                   EVAL      RecordData = %TRIM(TagName)+
     C                              %TRIM(ConvValue) + %TRIM(TagEnd)

      *  Attach CRLF at the end of each record line
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF
     C**********         Eval      Buffer = %TRIMR(ConvertAscii(BigString))                   CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Buffer = %TRIMR(ConvertAscii(BigString))                  CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             CSD053A
     C                   ENDIF

      * Write record to stream file
     C**********         EVAL      RC = WRITE(FileDesc : pBuffer :                            CSD053
     C**********                               %LEN(%TRIMR(Buffer)))                          CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       CSD053
     C                                         %LEN(%TRIMR(Output))*2)                        CDS053
     C                   ELSE                                                                CSD053A
     C                   EVAL      RC = WRITE(FileDesc : pBuffer:                            CSD053A
     C                                         %LEN(%TRIMR(Buffer)))                         CDS053A
     C                   ENDIF                                                               CSD053A

      *  If error writing to stream file
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod

     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                BA6020

     C                   IF        XMTAGN = DOCE                                              BA6020
     C                             AND BYPS = 'Y'                                             BA6020
     C                   EVAL      BYPS   = 'N'                                               BA6020
     C                   ENDIF                                                                BA6020
                                                                                              BA6020
      *  Write '<OutputInformation>' + System Fields information ONLY
      *  ONCE and AFTER writing the first line for Item Reference.

     C                   IF        WFlag = 'N'
     C                   EXSR      WRTSYS
     C                   EVAL      WFlag = 'Y'
     C                   ENDIF

      *  Read next record for Item Reference.
     C                   IF        #@ARCH = 'A'
     C     B2ITEM        READE     CGXXMLL0
     C                   ELSE
     C     B2ITEM        READE     CGUXMLL0
     C                   ENDIF

     C                   ENDDO
      *                                                                                       252870
     C                   IF        #@ARCH <> 'A'                                              252870
     C                   CLOSE     CGUXMLL0                                                   252870
     C                   ENDIF                                                                252870

      *  If <ROOT> element was found, output </DOCUMENT> and </ROOT> at the very end          BA6020
      *  of the extract                                                                       BA6020
      *                                                                                       BA6020
     C                   IF        BA6020 = 'Y'                                               BA6020
      *                                                                                       BA6020
      ***Output*</SYSTEMCUSTOM>*before*</DOCUMENT>.                                  BA6020 MD062272
     C**********         MOVE(P)   SYSCUSE       TagName                             BA6020 MD062272
     C**********         MOVE(P)   *BLANKS       TagValue                            BA6020 MD062272
     C**********         MOVE(P)   *BLANKS       TagEnd                              BA6020 MD062272
     C**********         EVAL      RecordData = %TRIM(TagName)                       BA6020 MD062272
     C**********         EVAL      BigString = %TRIM(RecordData) + CRLF              BA6020 MD062272
     C**********         Eval      Output = %TRIMR(%UCS2(BigString))                 BA6020 MD062272
     C**********         EVAL      RC = WRITE(FileDesc : %ADDR(Output):              BA6020 MD062272
     C**********                               %LEN(%TRIMR(Output))*2)               BA6020 MD062272
      **********                                                                     BA6020 MD062272
      ***If*error*writing*to*stream*file                                             BA6020 MD062272
     C**********         IF        RC = -1                                           BA6020 MD062272
     C**********         EVAL      DBFILE =  *BLANK                                  BA6020 MD062272
     C**********         EVAL      DBPGM  =  PSProcPgm                               BA6020 MD062272
     C**********         EVAL      DBASE  =  991                                     BA6020 MD062272
     C**********         EVAL      DBMOD  =  PSProcMod                               BA6020 MD062272
     C**********         EXSR      *PSSR                                             BA6020 MD062272
     C**********         ENDIF                                                       BA6020 MD062272
      **********                                                                     BA6020 MD062272
      ***Then*output*</DOCUMENT>.                                                    BA6020 MD062272
     C                   MOVE(P)   DOCE          TagName                                      BA6020
     C                   MOVE(P)   *BLANKS       TagValue                                     BA6020
     C                   MOVE(P)   *BLANKS       TagEnd                                       BA6020
     C                   EVAL      RecordData = %TRIM(TagName)                                BA6020
     C                   EVAL      BigString = %TRIM(RecordData) + CRLF                       BA6020
     C                   Eval      Output = %TRIMR(%UCS2(BigString))                          BA6020
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       BA6020
     C                                         %LEN(%TRIMR(Output))*2)                        BA6020
      *                                                                                       BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDSR

      /EJECT                                                                                  BA6020
      * +-------------------------------------------------------------+                       BA6020
      * ¦ Subr/WRTCLS  - Close ROOT element before file is closed.    ¦                       BA6020
      * +-------------------------------------------------------------+                       BA6020
     C     WRTCLS        BEGSR                                                                BA6020
      *                                                                                       BA6020
     C                   EVAL      BigString = %TRIM(ROOTE) + CRLF                            BA6020
     C                   EVAL      Output = %TRIMR(%UCS2(BigString))                          BA6020
     C                   EVAL      RC = WRITE(FileDesc : %ADDR(Output):                       BA6020
     C                                         %LEN(%TRIMR(Output))*2)                        BA6020
      *                                                                                       BA6020
      ** If error writing to stream file                                                      BA6020
      *                                                                                       BA6020
     C                   IF        RC = -1                                                    BA6020
     C                   EVAL      DBFILE =  *BLANK                                           BA6020
     C                   EVAL      DBPGM  =  PSProcPgm                                        BA6020
     C                   EVAL      DBASE  =  908                                              BA6020
     C                   EVAL      DBMOD  =  PSProcMod                                        BA6020
      *                                                                                       BA6020
     C                   EXSR      *PSSR                                                      BA6020
     C                   ENDIF                                                                BA6020
     C                   ENDSR                                                                BA6020
      *                                                                                       BA6020
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/*PSSR - Program Exception Error Handling Routine       ¦
      * ¦              Called automatically if a program error occurs,¦
      * ¦              or directly by the program code using EXSR.    ¦
      * ¦              This subroutine DUMPs the program just once.   ¦
      * +-------------------------------------------------------------+
     C     *PSSR         BEGSR

      *  Dump the program
     C                   DUMP

      *  Display Dbase Error screen
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

      * Set job switches
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   EVAL      RtnCode = '*ERROR '

      * End program
     C                   RETURN

     C                   ENDSR
      /EJECT
      ****************************************************************
      * ScanFld - Scan Tag Value for special characters '&', '<'     *
      *           and '>' and format field as necessary.             *
      ****************************************************************
     PScanFld          B
     DScanFld          PI            80
     D  TagValue                           LIKE(XMTAGV)

     D  SpcChar        S             10    INZ('&<>')
     D  SpcArr         S              1    DIM(10)
     D  ConvValue      S             80    INZ(*BLANKS)
     D  X              S              3  0
     D  WFound         S              1    INZ('N')
     D  SpcPos         S              3  0                                                  MD055442
     D  Y              S              3  0                                                  MD055442

      *  Load special chars to be scanned into a work array and
      *  initialise array index.
     C                   MOVEA     SpcChar       SpcArr
     C                   EVAL      X = 1
     C                   Eval      ConvValue = TagValue                                     MD055442

      *  Search Tag Value field for each special character
     C                   DOW       (X <= %ELEM(SpcArr)) AND
     C                             (SpcArr(X) <> *BLANK)

     C*****SpcArr(X)*****SCAN      TagValue                               90                MD055442
     C     SpcArr(X)     SCAN      ConvValue     SpcPos                   90                MD055442

      *  If any of special character is found, format the Tag Value field.
      *+------------------------------------------------------------------+
      *¦ NOTE : A problem is encountered if character '£' is FTPd to the  ¦
      *¦        PC. '£' seems to be translated into '$'. We found that    ¦
      *¦        '[' translates to '£' when FTPd. Hence was used here.     ¦
      *+------------------------------------------------------------------+
     C**********         IF        *IN90 = *ON                                              MD055442
     C                   DOW       *IN90 = *ON                                              MD055442
     C                   EVAL      WFound = 'Y'
     C**********         EVAL      ConvValue = '<!£CDATA£' +                                MD027486
     C**********         EVAL      ConvValue = '<![CDATA[' +                       MD027486 MD055442
     C**********                     %TRIM(TagValue) + ']]>'                                MD055442
      *                                                                                     MD055442
      * Substitute the special character instead of using CDATA                             MD055442
     C                   If        SpcArr(X) = '&'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&amp;' + %SUBST(ConvValue:SpcPos+1)                     MD055442
     C                   Eval      Y = SpcPos + 5                                           MD055442
     C                   Endif                                                              MD055442
     C                   If        SpcArr(X) = '<'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&lt;' + %SUBST(ConvValue:SpcPos+1)                      MD055442
     C                   Eval      Y = SpcPos + 4                                           MD055442
     C                   Endif                                                              MD055442
     C                   If        SpcArr(X) = '>'                                          MD055442
     C                   Eval      ConvValue = %SUBST(ConvValue:1:SpcPos-1) +               MD055442
     C                             '&gt;' + %SUBST(ConvValue:SpcPos+1)                      MD055442
     C                   Eval      Y = SpcPos + 4                                           MD055442
     C                   Endif                                                              MD055442
      *                                                                                     MD055442
     C**********         LEAVE                                                              MD055442
     C**********         ENDIF                                                              MD055442
     C     SpcArr(X)     SCAN      ConvValue:Y   SpcPos                   90                MD055442
     C                   ENDDO                                                              MD055442

      *  Scan for next special character.
     C                   EVAL      X = X + 1
     C                   ENDDO

      *  If no special chars found in the field value, pass original
      *  field to calling procedure.
     C                   IF        WFound = 'N'
     C                   EVAL      ConvValue = TagValue
     C                   ENDIF

     C                   RETURN    ConvValue

     P                 E
      ********************************************************************  **
      * Convert to ASCII                                                 *
      ********************************************************************  **
     P*ConvertAscii     B                                                                     CSD053
     D*ConvertAscii     PI          1000                                                      CSD053
     D*InputData                    1000                                                      CSD053
      **********                                                                              CSD053
     D*ConvData*        S           1000                                                      CSD053
     D*Length***        S              5  0                                                   CSD053
     D*LengthCnv        S              5  0                                                   CSD053
     D*LengthOutBuf     S              5  0                                                   CSD053
     D*TableName        S             10                                                      CSD053
     D*LibName**        S             10                                                      CSD053
     D*DBCSLanguage     S             10                                                      CSD053
     D*ShftOutShftIn    S              1                                                      CSD053
     D*TypeOfConv       S             10                                                      CSD053
      **********                                                                              CSD053
     C*****' '**         CHECKR    InputData     Length                                       CSD053
      **********                                                                              CSD053
     C**********         CALL      'QDCXLATE'                                                 CSD053
     C**********         PARM                    Length                                       CSD053
     C**********         PARM                    InputData                                    CSD053
     C**********         PARM      'CGASCII'     TableName                                    CSD053
      **********                                                                              CSD053
     C**********         RETURN    InputData                                                  CSD053
      **********                                                                              CSD053
     P**********       E                                                                      CSD053
                                                                                             CSD053A
      ********************************************************************                   CSD053A
      * Convert to ASCII                                                                     CSD053A
      ********************************************************************                   CSD053A
     PConvertAscii     B                                                                     CSD053A
     DConvertAscii     PI          1000                                                      CSD053A
     DInputData                    1000                                                      CSD053A
     DConvData         S           1000                                                      CSD053A
     DLength           S              5  0                                                   CSD053A
     DLengthCnv        S              5  0                                                   CSD053A
     DLengthOutBuf     S              5  0                                                   CSD053A
     DTableName        S             10                                                      CSD053A
     DLibName          S             10                                                      CSD053A
     DDBCSLanguage     S             10                                                      CSD053A
     DShftOutShftIn    S              1                                                      CSD053A
     DTypeOfConv       S             10                                                      CSD053A
                                                                                             CSD053A
     C     ' '           CHECKR    InputData     Length                                      CSD053A
                                                                                             CSD053A
     C                   CALL      'QDCXLATE'                                                CSD053A
     C                   PARM                    Length                                      CSD053A
     C                   PARM                    InputData                                   CSD053A
     C                   PARM      'CGASCII'     TableName                                   CSD053A
                                                                                             CSD053A
     C                   RETURN    InputData                                                 CSD053A
                                                                                             CSD053A
     P                 E                                                                     CSD053A
