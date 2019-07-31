     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Input BoE Repair')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPRPR1 - LE Facilities Input BOE Repair                  *
      *                                                               *
      *  Function:  This module handles window processing when        *
      *             transaction is entered via RPR                    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Invalids File
     FLEIFCIPY0 IF   E           K Disk    Infsr(*PSSR)
      *
      ** Display file for window
     FLEFCIPRPDFCF   E             WORKSTN
 
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
      *
      ** DS Definition of DATA
     D/COPY QWINDSRC,LEFCIPDTA
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Add 1 onto elements in array for each field on window
     D @EI             S              1    DIM(60)
 
      **---------------------------------------------------------------
      ** External File DS
      **---------------------------------------------------------------
      *
      ** Error indicators (OK#S)
     D OKFlags       E DS                  EXTNAME(LEEFCIPX0)
      *
      ** Midas LE Facility input extra data layout File
     D NwFCIPScnFmt  E DS                  EXTNAME(LEFCEXPD)
      *
      ** LE Facility BOE Valid File
     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCIPX0)
 
      **---------------------------------------------------------------
      ** Definitions of Variables
      **---------------------------------------------------------------
 
      ** Entry Parameters
     D p_Actn          S              1
     D p_W8rtn         S              7
     D p_Wlen          S              3  0
     D p_Wwid          S              3  0
     D p_Srow          S              3  0
     D p_Scol          S              3  0
     D p_Title         S              7
     D p_Spare2        S            256
 
      ** Parameters for call to Y2SNMGC
     D p_ZaPgmq        S             10
     D p_ZaPgrl        S              5
     D p_ZaMsId        S              7
     D p_ZaMsgf        S             10
     D p_ZaMsda        S            132
     D p_ZaMstp        S              7
      *
      ** Array Index
     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)
      *
      ** Standards Output parameters
     D @INKC           S              1
     D @INKL           S              1
 
     D C               S              2P 0 INZ(0)
     D E               S              2P 0 INZ(0)
     D WProcess        S              1
     D Prtcd           S              7
     D p_Text          S            132
 
     D k_FrntId        S                   Like(BYFRNT)
     D k_TmeStp        S                   Like(BYTIME)
 
      **---------------------------------------------------------------
      ** Calculation Specs
      **---------------------------------------------------------------
 
     C                   EXSR      SrInit
 
     C                   DOU       WProcess = 'N'
     C                   EVAL      @EI = OKFLAGS
     C                   EVAL      C = 1
     C                   EVAL      E = 50
 
     C                   DOU       C > 10
     C                   IF        @EI(C) = 'N' or @EI(C) = 'W'
     C                   EVAL      *IN(E) = '1'
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO
      *
      ** Write Error Message to Subfile
     C                   Z-ADD     1             C
     C                   DOW       C <= ArrayMax and
     C                             FldNameArr(C) <> *Blanks
     C                   MOVEL     MsgIdArr(C)   p_ZaMsId
     C                   MOVEL     MsgDtaArr(C)  p_ZaMsda
     C                   EXSR      ZaSnMs
     C                   EVAL      C = C + 1
     C                   ENDDO
 
     C                   IF        Idx > 0
     C                   WRITE     LEFCIPRPF0
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
      ** Display the window
     C                   EXFMT     LEFCIPRPF0
 
      ** Clear The Message Subfile
     C                   EXSR      SrClear
 
     C                   EVAL      @INKC = *InKC
     C                   EVAL      @INKL = *InKL
 
      ** Initialize Variables
     C                   EXSR      SrVClr
 
      ** Process Function Keys
     C                   SELECT
      ** F3 is pressed
     C                   WHEN      *InKC
     C                   EXSR      SrExit
      ** F12 is pressed
     C                   WHEN      *InKL
     C                   EXSR      SrPrev
      ** Other keys
     C                   OTHER
     C                   IF        p_Actn = 'E'
     C                   EVAL      *In20 = *On
     C                   EVAL      WProcess = 'N'
     C                   ELSE
     C                   EXSR      SrValid
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EXSR      SrTerm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Initialization Subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
     C                   EVAL      ##pgm  = PsProcName
     C                   EVAL      SwRow = p_SRow
     C                   EVAL      SwCol = p_SCol
     C                   EVAL      p_ZaMsgf = 'GBBYUSRMSG'
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    p_Title
     C                   PARM                    p_ZaMsgf
     C                   PARM                    p_Text
     C                   MOVEL     p_Text        Stitl
 
     C                   EVAL      k_FrntId = BYFRNT
     C                   EVAL      k_TmeStp = BYTIME
     C     K@FcId        CHAIN     LEIFCIX0
     C                   IF        %FOUND()
     C                   EVAL      LEUROX = LIEURO
     C                   EVAL      #0FCTY = LIEURO
     C                   ELSE
     C                   EVAL      LEUROX = *blanks
     C                   EVAL      #0FCTY = *blanks
     C                   ENDIF
     C                   EXSR      SrVClr
 
     C                   IF        p_Actn = 'E'
     C                   EVAL      *In20 = *On
     C                   ELSE
 
      ** Call LE Facility BOE Validation
     C                   CALLB     'LEFCIPVAL1'
     C                   PARM                    p_Actn
     C                   PARM                    Data
     C                   PARM                    NwFCIPScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwFCIPFilFmt
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZaSnMs - Send Message                                         *
      *                                                               *
      *****************************************************************
 
     C     ZaSnMs        BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##Pgm         p_ZaPgmq
     C                   PARM                    p_ZaPgrl
     C                   PARM                    p_ZaMsId
     C                   PARM                    p_ZaMsgf
     C                   PARM                    p_ZaMsda
     C                   PARM                    p_ZaMstp
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClear - Clear Fields                                        *
      *                                                               *
      *****************************************************************
 
     C     SrClear       BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    p_ZaPgmq
     C                   PARM      '*SAME'       p_ZaPgrl
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVClr - Clear Variables                                      *
      *                                                               *
      *****************************************************************
 
     C     SrVClr        BEGSR
 
     C                   MOVEA     '000000'      *In(50)
     C                   EVAL      OkFlagS    =  *ALL'Y'
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIdArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
     C                   EVAL      p_W8rtn    = *Blanks
     C                   EVAL      Idx        = *Zeros
     C                   EVAL      WIdx       = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExit - Exit Program                                         *
      *                                                               *
      *****************************************************************
 
     C     SrExit        BEGSR
 
     C                   EVAL      p_W8rtn  = 'Y2U9999'
     C                   EVAL      WProcess = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrev - Previous                                             *
      *                                                               *
      *****************************************************************
 
     C     SrPrev        BEGSR
 
     C                   EVAL      p_W8rtn  = 'USR0790'
     C                   EXSR      SrClear
     C                   EVAL      WProcess = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValid - Validate Record                                     *
      *                                                               *
      *****************************************************************
 
     C     SrValid       BEGSR
 
     C                   EVAL      LEUROX = #0FCTY
 
      ** Call LE Facility BOE Validation
     C                   CALLB     'LEFCIPVAL1'
     C                   PARM                    p_Actn
     C                   PARM                    Data
     C                   PARM                    NwFCIPScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwFCIPFilFmt
 
     C                   IF        Idx = 0
     C                   EVAL      WProcess = 'N'
     C                   EVAL      BYEURO = LEUROX
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTerm - Terminate Program                                    *
      *                                                               *
      *****************************************************************
 
     C     SrTerm        BEGSR
 
     C                   EVAL      *InLR = *On
     C                   RETURN
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    p_Actn
     C                   PARM                    Data
     C                   PARM                    p_W8rtn
     C                   PARM                    p_Wlen
     C                   PARM                    p_Wwid
     C                   PARM                    p_Srow
     C                   PARM                    p_Scol
     C                   PARM                    p_Title
     C                   PARM                    p_Spare2
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
      *
      ** Key Lists
     C     K@FcId        KLIST
     C                   KFLD                    k_FrntId
     C                   KFLD                    k_TmeStp
 
     C                   ENDSR
 
