     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Format security descriptions')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZSDESC - Format Security Descriptions                        *
      *                                                               *
      *  Function:     This module will format security               *
      *                descriptions.                                  *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZSDESC        *
      *  subroutine.  The subroutine consists of three /COPY members. *
      *  Any changes done to this module must also be reflected in    *
      *  the /COPY members.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 208241             Date 22Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE016  *CREATE    Date 10Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  208241 - Applied core fix 127566 so that this ILE version is *
      *           in-synch with the /CPY version.  Added fix to       *
      *           populate century field for output.                  *
      *  CSE016 - Extended Security Descriptions                      *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D ASS             S              1    DIM(20)
     D AON             S              1    DIM(50)
     D ACR             S              1    DIM(11)
     D APR             S              1    DIM(15)
     D ADT             S              1    DIM(7)
 
     D AONDS           DS
     D  AON2                   1     50
     D  AONM                   1     50
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Define input fields and clear output fields
      *
     C                   MOVE      ZSRPN         ZSRPN            20
     C                   MOVE      ZSFN1         ZSFN1            30
     C                   MOVE      ZSFN2         ZSFN2            30
     C                   MOVE      ZRSFD         ZRSFD             1
      *
     C                   MOVE      *BLANK        ZRNME            41
     C                   MOVE      *BLANK        ZFNM1            30
     C                   MOVE      *BLANK        ZFNM2            50
     C                   MOVE      *BLANK        ZFNM3            50
     C                   MOVEA     *BLANK        AON
      *
      ** Check which input field/s entered
      ** If Report Name blank - Full Name format required
      *
     C     ZSRPN         IFEQ      *BLANK
     C                   GOTO      FLLFMT
     C                   ENDIF
      *
      ** Move Report Name to array
      *
     C                   MOVEA     ZSRPN         ASS
     C                   Z-ADD     20            ZE                2 0
      *
      ** Find first blank working backwards through Name array
      *
     C     ASS(ZE)       DOUNE     ' '
     C     ZE            OREQ      0
     C     ASS(ZE)       IFEQ      ' '
     C     ZE            SUB       1             ZE
     C                   ENDIF
     C                   ENDDO
      *
      ** Move Name to output description
      *
     C                   Z-ADD     0             ZO                2 0
     C                   Z-ADD     0             ZS                2 0
     C     ZE            DOUEQ     ZS
     C                   ADD       1             ZO
     C                   ADD       1             ZS
     C                   MOVE      ASS(ZS)       AON(ZO)
     C                   ENDDO
      *
      ** Insert separator blank between Name and Coupon Rate
      *
     C                   ADD       1             ZO
     C                   MOVE      ' '           AON(ZO)
      *
     C                   GOTO      CPRFMT
      *
     C     FLLFMT        TAG
      *
      ** Check that full name has been entered
      *
     C     ZSFN1         IFEQ      *BLANK
     C                   GOTO      EZDESC
     C                   ENDIF
      *
     C                   Z-ADD     0             ZO
      *
      ** If Redemption in Sec. Desc is 'Y' -
      **         format Call/Put Ind, Redemption Price and Redemption Date
      *
     C     ZRSFD         IFEQ      'Y'
      *
      ** Move Put/Call Ind to output if present
      *
     C     SCPI          IFNE      *BLANK
     C                   MOVE      SCPI          AON(1)
     C                   MOVE      ' '           AON(2)
     C                   Z-ADD     2             ZO
     C                   ENDIF
      *
      ** Move Redemption Price to array to find leading and trailing zeros
      *
     C     SCPP          IFEQ      0
     C                   GOTO      RDTFMT
     C                   ENDIF
      *
     C                   MOVE      SCPP          ZSCPP            15
     C                   MOVEA     ZSCPP         APR
      *
     C                   Z-ADD     1             ZS
     C     APR(ZS)       DOUNE     '0'
     C     ZS            ORGT      7
     C     APR(ZS)       IFEQ      '0'
     C                   ADD       1             ZS
     C                   ENDIF
     C                   ENDDO
      *
      ** Move 1st 7 digits to output ignoring leading zeros
      *
     C     ZS            IFLE      7
     C     ZS            DOUGT     7
     C                   ADD       1             ZO
     C                   MOVE      APR(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
     C                   ENDIF
      *
      ** Find trailing zeros
      *
     C                   Z-ADD     15            ZE
     C     ZE            DOULT     8
     C     APR(ZE)       ORNE      '0'
     C     APR(ZE)       IFEQ      '0'
     C     ZE            SUB       1             ZE
     C                   ENDIF
     C                   ENDDO
      *
      ** Move digits after dec point to output ignoring trailing zeros
      *
     C     ZE            IFGT      7
     C                   ADD       1             ZO
     C                   MOVE      '.'           AON(ZO)
     C                   Z-ADD     8             ZS
     C     ZS            DOUGT     ZE
     C                   ADD       1             ZO
     C                   MOVE      APR(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
     C                   ENDIF
      *
      ** Insert separator blank between Redemption Price and Date
      *
     C                   ADD       1             ZO
     C                   MOVE      ' '           AON(ZO)
      *
     C     RDTFMT        TAG
      *
      ** Call ZDATE2 to convert Redemption Date to DDMMMYY
      *
     C     SCPD          IFEQ      0
     C                   GOTO      CPRFMT
     C                   ENDIF
     C*
     C                   Z-ADD     SCPD          ZDAYNO            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEA     ZADATE        ADT
      *
      ** Check for leading blank
      *
     C     ADT(1)        IFEQ      ' '
     C                   Z-ADD     2             ZS
     C                   ELSE
     C                   Z-ADD     1             ZS
     C                   ENDIF
      *
      ** Move Redemption Date to output
      *
     C     ZS            DOUGT     7
     C                   ADD       1             ZO
     C                   MOVE      ADT(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
      *
      ** Move separator blank between Name and Coupon Rate
      *
     C                   ADD       1             ZO
     C                   MOVE      ' '           AON(ZO)
      *
     C                   ENDIF
      *
      ** Move Coupon Rate to array to find leading and trailing zeros
      *
     C     CPRFMT        TAG
      *
     C     CPNR          IFEQ      0
     C     MATY          ANDEQ     0                                                          208241
     C                   GOTO      MATFMT
     C                   ENDIF
      *                                                                                       208241
     C     CPNR          IFEQ      0                                                          208241
     C     MATY          ANDNE     0                                                          208241
     C     ZE            ADD       2             ZZ                2 0                        208241
     C                   MOVEA     '0'           AON(ZZ)                                      208241
     C                   ADD       1             ZO                                           208241
     C                   ENDIF                                                                208241
      *
     C     *LIKE         DEFINE    CPNR          ZZCPNR
     C                   Z-ADD     CPNR          ZZCPNR
     C     CPNR          IFLT      0
     C                   MULT      -1            ZZCPNR
     C                   ENDIF
     C                   MOVE      ZZCPNR        ZCPNRX           11
     C                   MOVEA     ZCPNRX        ACR
      *
      ** Find leading zeros
      *
     C                   Z-ADD     1             ZS                2 0
     C     ACR(ZS)       DOUNE     '0'
     C     ZS            ORGT      4
     C     ACR(ZS)       IFEQ      '0'
     C                   ADD       1             ZS
     C                   ENDIF
     C                   ENDDO
      *
      ** Move first 4 digits of Coupon Rate to output line ignoring
      **  leading zeros
      *
     C     ZS            IFLE      4
     C     ZS            DOUGT     4
     C                   ADD       1             ZO
     C                   MOVE      ACR(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
     C                   ENDIF
      *
      ** Find trailing zeros of Coupon Rate
      *
     C                   Z-ADD     11            ZE                2 0
     C     ZE            DOULT     5
     C     ACR(ZE)       ORNE      '0'
     C     ACR(ZE)       IFEQ      '0'
     C     ZE            SUB       1             ZE
     C                   ENDIF
     C                   ENDDO
      *
      ** If digits present after decimal point - move to output line
      **   ignoring trailing zeros
      *
     C     ZE            IFGT      4
     C                   ADD       1             ZO
     C                   MOVE      '.'           AON(ZO)
     C                   Z-ADD     5             ZS
     C     ZS            DOUGT     ZE
     C                   ADD       1             ZO
     C                   MOVE      ACR(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
     C                   ENDIF
      *
      ** Insert minus sign if Coupon Rate negative
      *
     C     CPNR          IFLT      0
     C                   ADD       1             ZO
     C                   MOVE      '-'           AON(ZO)
     C                   ENDIF
      *
      ** Insert separator blank between Coupon Rate and Maturity Date
      *
     C                   ADD       1             ZO
     C                   MOVE      ' '           AON(ZO)
      *
      ** If Maturity Date present - convert to date DD/MMM/YY
      *
     C     MATFMT        TAG
      *
     C     MATY          IFEQ      00000
     C     MATY          OREQ      99999
     C                   GOTO      MDESC
     C                   ENDIF
      *
      ** Call ZDATE2 to convert date and move date to array to test
      **   for leading blank
      *
     C                   Z-ADD     MATY          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVEA     ZADATE        ADT
      *
     C     ADT(1)        IFEQ      ' '
     C                   Z-ADD     2             ZS
     C                   ELSE
     C                   Z-ADD     1             ZS
     C                   ENDIF
      *                                                                                       208241
      ***  Populate century field for output.                                                 208241
      *                                                                                       208241
     C     MATY          SUB       1             ZDAYN1            5 0                        208241
     C     ZDAYN1        DIV       1461          ZLYR              2 0                        208241
     C     ZLYR          MULT      4             ZWRK3             3 0                        208241
     C     ZWRK3         ADD       72            ZWRK3                                        208241
     C     ZWRK3         DIV       100           CCR               2 0                        208241
     C     CCR           ADD       19            CCR                                          208241
     C                   MOVE      CCR           CC                2                          208241
      *
      ** Move Maturity Date to output line
      *
     C*****ZS***         DOUGT     7                                                          208241
     C     ZS            DOUGT     5                                                          208241
     C                   ADD       1             ZO
     C                   MOVE      ADT(ZS)       AON(ZO)
     C                   ADD       1             ZS
     C                   ENDDO
      *                                                                                       208241
      ***  Move redemption century to output                                                  208241
      *                                                                                       208241
     C                   ADD       1             ZO                                           208241
     C                   MOVEA     CC            AON(ZO)                                      208241
     C                   ADD       1             ZO                                           208241
      *                                                                                       208241
      ***  Move redemption year to output                                                     208241
      *                                                                                       208241
     C     ZS            DOUGT     7                                                          208241
     C                   ADD       1             ZO                                           208241
     C                   MOVE      ADT(ZS)       AON(ZO)                                      208241
     C                   ADD       1             ZS                                           208241
     C                   ENDDO                                                                208241
      *
     C     MDESC         TAG
      *
      ** Move formatted output line to output parameter
      *
     C                   MOVEA     AON           AON2
      *
     C     ZSRPN         IFNE      *BLANK
     C                   MOVEL     AONM          ZRNME
     C                   ELSE
     C                   MOVE      ZSFN1         ZFNM1
     C     ZSFN2         IFNE      *BLANK
     C                   MOVEL     ZSFN2         ZFNM2
     C                   MOVEL     AONM          ZFNM3
     C                   ELSE
     C                   MOVEL     AONM          ZFNM2
     C                   ENDIF
     C                   ENDIF
      *
     C     EZDESC        TAG
      *
     C                   RETURN
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZSRPN
     C                   PARM                    ZSFN1
     C                   PARM                    ZSFN2
     C                   PARM                    CPNR             11 7
     C                   PARM                    MATY              5 0
     C                   PARM                    SCPP             15 8
     C                   PARM                    SCPD              5 0
     C                   PARM                    ZRSFD
     C                   PARM                    SCPI              1
     C                   PARM                    ZRNME
     C                   PARM                    ZFNM1
     C                   PARM                    ZFNM2
     C                   PARM                    ZFNM3
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
