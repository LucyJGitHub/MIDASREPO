     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*XBIA*  CRTPF QTEMP/OUTFILE RCDLEN(80)                               *
/*XBIB*  OVRDBF FILEOUT QTEMP/OUTFILE                                 *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Generate Meridian sub-message')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGENMDNR1 - Generate Meridian sub-message                   *
      *                                                               *
      *  Function:  This module reads records from the Export Format  *
      *             Fields file and writes them to a temporary file   *
      *             in QTEMP in the format of a Meridian 1.7          *
      *             Message or Sub-Message.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX001  *CREATE    Data 01Jan00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
      /EJECT
     FMXEXFDL2  IF   E           K DISK
 
     FMXEXFFPD  IF   E           K DISK
 
      * The prefix keyword is used to rename the field to FOUTFILE to avoid
      * conflict with the file name.
     FFILEOUT   O    E             DISK    PREFIX(F)
 
      * ReturnCode constants
     D FileError       C                   Const('FileError')
     D NoRecord        C                   Const('NoRecord')
 
      * Meridian constants
 
     D TagMsgStart     C                   '<MESSAGE>'
     D TagSubMsgStart  C                   '<COMMONBLOCK>'
 
     D TagSystem       C                   '<SYSTEM>EXPORT'
 
     D TagMsgEnd       C                   '</MESSAGE>'
     D TagSubMsgEnd    C                   '</COMMONBLOCK>'
 
     D TagFieldStart   C                   '<FIELD>'
     D TagFieldEnd     C                   '</FIELD>'
 
     D TagFieldLength  C                   '<LENGTH>'
 
     D TagFieldType    C                   '<TYPE>'
 
     D TagBlank        C                   '        '
 
     D TagFldDescStr   C                   '<DESCRIPTION>'
     D TagFldDescEnd   C                   '</DESCRIPTION>'
 
      * Field Name Length information
     D MaxMdnFldNameLen...
     D                 C                   CONST(32)
     D EffMaxMdnFldNameLen...
     D                 S              3P 0
 
      * Parameters
      *   Format to be processed
     D InFormat        S             10A
      *   Target Meridian (Sub) Message name
     D TargetName      S             32A
      *   Prefix to be applied
     D Prefix          S             10A
      *   Generate a MESSAGE or a SUBMESSAGE
     D GenType         S             11A
      *   Do Type Matching on message
     D TypeMatch       S              1A
      *   Return Code
     D ReturnCode      S             10A
 
      * Work Fields
     D KeyFile         S             10A
     D KeySequence     S              1A
     D Length          S             10S 0
 
     D DataFound       S              1A
     D LastUsedElement...
     D                 S              2P 0
     D LUE             S              2P 0
     D NextDesc        S              2P 0
 
      *  WHDS01        78A
      * Description fields as an array
     D DescFlds        DS
     D  WHDS01
     D  WHDS02
     D  WHDS03
     D  WHDS04
     D  WHDS05
     D  WHDS06
     D  WHDS07
     D  WHDS08
     D  WHDS09
     D  WHDS10
     D  WHDS11
     D DescFldsArray                       like(WHDS01) dim(11)
     D                                     overlay(DescFlds)
 
      * Use the format received as a parameter to initially access the
      *  Export Format Details file to get details of the file etc
      *  associated with the format.
     C     InFormat      CHAIN(E)  MXEXFDL2
     C                   IF        %Error
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        NOT %Found
     C                   EVAL      ReturnCode = NoRecord
     C                   RETURN
     C                   ENDIF
 
      * Use the retrieved file name etc to access all the records from the
      *  Export Format Fields file, and write each one to the target file.
 
      * - write out the initial 'once only' data
     C                   IF        GenType = '*MESSAGE'
     C                   EVAL      FOUTFILE = TagMsgStart + TargetName
     C                   ELSE
     C                   EVAL      FOUTFILE = TagSubMsgStart + TargetName
     C                   ENDIF
     C                   WRITE     OUTFILE
 
     C                   EVAL      FOUTFILE = TagSystem
     C                   WRITE     OUTFILE
 
      * - set up the prefix if required
     C                   IF        Prefix = '*FROMDBF'
     C                   EVAL      Prefix = EXFILE
     C                   ENDIF
 
      * - set up the effective max length for a field name
     C                   IF        Prefix <> '*DFT'
     C                   EVAL      EffMaxMdnFldNameLen = MaxMdnFldNameLen -
     C                               %len(%trim(Prefix))
     C                   ENDIF
 
      * - loop around all the records processing each one
     C                   EXSR      MAINLOOP
 
      * - write the end tags
     C                   IF        GenType = '*MESSAGE'
     C                   EVAL      FOUTFILE = TagMsgEnd
     C                   ELSE
     C                   EVAL      FOUTFILE = TagSubMsgEnd
     C                   ENDIF
     C                   WRITE     OUTFILE
 
     C                   EVAL      FOUTFILE = TagBlank
     C                   WRITE     OUTFILE
 
     C                   SETON                                        LR
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MainLoop - Subroutine to do the main processing, in a loop    *
      *                                                               *
      *****************************************************************
 
     C     MAINLOOP      BEGSR
 
 
      * Set up the keys and position to the start of the records
     C                   EVAL      KeyFile = EXFILE
     C                   EVAL      KeySequence = EXFSQN
 
     C     MXEXFFK       SETLL     MXEXFFPD
     C                   IF        %Error
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        NOT %Equal
     C                   EVAL      ReturnCode = NoRecord
     C                   RETURN
     C                   ENDIF
 
     C     MXEXFFK       READE(E)  MXEXFFPD                                     *
     C                   IF        %Error
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Process all records in turn
     C                   DOW       NOT %EOF
 
      * Only output data if the Include In Export flag is on
     C                   IF        WHINEX = 'Y'
 
      * Output <FIELD>, <LENGTH) and </FIELD> records
 
      * - for <FIELD> record include the Prefix if specified
     C                   IF        Prefix = '*DFT'
     C                   EVAL      FOUTFILE = TagFieldStart + WHMFNM
     C                   ELSE
     C                   EVAL      FOUTFILE = TagFieldStart +
     C                                        %trim(Prefix) +
     C                              %subst(WHMFNM:1:EffMaxMdnFldNameLen)
     C                   ENDIF
     C                   WRITE     OUTFILE
 
      * - for <LENGTH> record, use Number of Digits + 2 for Packed/Signed
      *   and Number of Bytes for all other cases
     C                   IF        WHFLDT = 'P' OR WHFLDT = 'S'
     C                   EVAL      Length = WHFLDD + 2
     C                   ELSE
     C                   EVAL      Length = WHFLDB
     C                   ENDIF
 
      *    - convert length to alpha before output
     C                   EVAL      FOUTFILE = TagFieldLength +
     C                              %trim(%editc(Length:'3'))
 
     C                   WRITE     OUTFILE
 
      * - for <TYPE> record, output only if numeric (default is String)
     C                   IF        TypeMatch = 'Y'
     C                   IF        WHFLDT = 'P' OR WHFLDT = 'S'
     C                   EVAL      FOUTFILE = TagFieldType + 'Number'
     C                   WRITE     OUTFILE
     C                   ENDIF
     C                   ENDIF
 
      * - Description records
     C                   EXSR      Description
 
      * - </FIELD> record
     C                   EVAL      FOUTFILE = TagFieldEnd
     C                   WRITE     OUTFILE
 
     C                   ENDIF
 
      * Get next record
     C     MXEXFFK       READE(E)  MXEXFFPD                                     *
     C                   IF        %Error
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Description - output Description records if any are present   *
      *                                                               *
      *****************************************************************
 
     C     Description   BEGSR
 
      * Check to see if there is any description data present
     C                   EVAL      DataFound = 'N'
     C                   EVAL      LastUsedElement = 0
 
     C     1             DO        11            NextDesc
 
     C                   IF        DescFldsArray(NextDesc) <> *BLANK
     C                   EVAL      DataFound = 'Y'
     C                   EVAL      LastUsedElement = NextDesc
     C                   ENDIF
 
     C                   ENDDO
 
      * If there is any description data present output
      * - starting tag
      * - all entries (including blank ones) up to the last non-blank one
      * - ending tag
 
     C                   IF        DataFound = 'Y'
 
     C                   EVAL      FOUTFILE = TagFldDescStr
     C                   WRITE     OUTFILE
 
     C                   EVAL      LUE = LastUsedElement
     C     1             DO        LUE           NextDesc
     C                   EVAL      FOUTFILE = DescFldsArray(NextDesc)
     C                   WRITE     OUTFILE
     C                   ENDDO
 
     C                   EVAL      FOUTFILE = TagFldDescEnd
     C                   WRITE     OUTFILE
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    InFormat
     C                   PARM                    TargetName
     C                   PARM                    Prefix
     C                   PARM                    GenType
     C                   PARM                    TypeMatch
     C                   PARM                    ReturnCode
 
     C     MXEXFFK       KLIST
     C                   KFLD                    KeyFile
     C                   KFLD                    KeySequence
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
